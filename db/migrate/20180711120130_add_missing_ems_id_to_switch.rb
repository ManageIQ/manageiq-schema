class AddMissingEmsIdToSwitch < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => "ems_id"

    has_many :host_switches
    has_many :switches, :through => :host_switches
  end

  class HostSwitch < ActiveRecord::Base
    belongs_to :host
    belongs_to :switch
  end

  class Switch < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => "ems_id"

    has_many :hosts, :through => :host_switches
    has_many :host_switches
  end

  def up
    say_with_time("Add missing ems_id to switch") do
      connection.execute <<-SQL
        UPDATE switches
          SET ems_id=hosts.ems_id
          FROM host_switches
          INNER JOIN hosts ON hosts.id = host_switches.host_id
          WHERE host_switches.switch_id = switches.id
             AND hosts.ems_id IS NOT NULL
             AND switches.type = 'ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch'
      SQL
    end
  end
end
