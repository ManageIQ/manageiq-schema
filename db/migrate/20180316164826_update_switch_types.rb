class UpdateSwitchTypes < ActiveRecord::Migration[5.0]
  VMWARE_HOSTS                      = %w(ManageIQ::Providers::Vmware::InfraManager::Host
                                         ManageIQ::Providers::Vmware::InfraManager::HostEsx).freeze
  VMWARE_DISTRIBUTED_VIRTUAL_SWITCH = "ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch".freeze
  VMWARE_HOST_VIRTUAL_SWITCH        = "ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch".freeze

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    has_many :host_switches,                        :class_name => "UpdateSwitchTypes::HostSwitch"
    has_many :switches, :through => :host_switches, :class_name => "UpdateSwitchTypes::Switch"
  end

  class HostSwitch < ActiveRecord::Base
    belongs_to :host,   :class_name => "UpdateSwitchTypes::Host"
    belongs_to :switch, :class_name => "UpdateSwitchTypes::Switch"
  end

  class Switch < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    has_many :host_switches,                     :class_name => "UpdateSwitchTypes::HostSwitch"
    has_many :hosts, :through => :host_switches, :class_name => "UpdateSwitchTypes::Host"
  end

  def up
    say_with_time("Setting switch types") do
      # Switches connected to VMware hosts which are shared are DVS type
      Switch.distinct.where(:type => nil, :shared => true).joins(:hosts).where(:hosts => {:type => VMWARE_HOSTS})
            .update_all(:type => VMWARE_DISTRIBUTED_VIRTUAL_SWITCH)

      # Switches connected to VMware hosts which are not shared are standard host switches
      Switch.distinct.where(:type => nil, :shared => [false, nil]).joins(:hosts).where(:hosts => {:type => VMWARE_HOSTS})
            .update_all(:type => VMWARE_HOST_VIRTUAL_SWITCH)
    end
  end

  def down
    say_with_time("Clearing all switch types") do
      Switch.where(:type => [VMWARE_DISTRIBUTED_VIRTUAL_SWITCH, VMWARE_HOST_VIRTUAL_SWITCH]).update_all(:type => nil)
    end
  end
end
