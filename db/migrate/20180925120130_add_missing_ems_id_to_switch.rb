class AddMissingEmsIdToSwitch < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => "ems_id", :class_name => "AddMissingEmsIdToSwitch::ExtManagementSystem"

    has_many :host_switches, :class_name => "AddMissingEmsIdToSwitch::HostSwitch"
    has_many :switches, :through => :host_switches, :class_name => "AddMissingEmsIdToSwitch::Switch"
  end

  class HostSwitch < ActiveRecord::Base
    belongs_to :host, :class_name => "AddMissingEmsIdToSwitch::Host"
    belongs_to :switch, :class_name => "AddMissingEmsIdToSwitch::Switch"
  end

  class Switch < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => "ems_id", :class_name => "AddMissingEmsIdToSwitch::ExtManagementSystem"
    belongs_to :host, :class_name => "AddMissingEmsIdToSwitch::Host"

    has_many :hosts, :through => :host_switches, :class_name => "AddMissingEmsIdToSwitch::Host"
    has_many :host_switches, :class_name => "AddMissingEmsIdToSwitch::HostSwitch"
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

      connection.execute <<-SQL
        UPDATE switches
          SET host_id=hosts.id
          FROM host_switches
          INNER JOIN hosts ON hosts.id = host_switches.host_id
          WHERE host_switches.switch_id = switches.id
             AND switches.type = 'ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch'
      SQL
    end
  end
end
