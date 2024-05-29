require_migration

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
end

describe AddMissingEmsIdToSwitch do
  let(:switch_stub) { migration_stub(:Switch) }
  let(:host_stub) { migration_stub(:Host) }
  let(:ems_stub) { migration_stub(:ExtManagementSystem) }
  let(:host_switch_stub) { migration_stub(:HostSwitch) }

  migration_context :up do
    it "migrates a series of representative rows" do
      # Emses
      vmware_ems = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      redhat_ems = ems_stub.create!(:type => "ManageIQ::Providers::Redhat::InfraManager")
      lenovo_ems = ems_stub.create!(:type => "ManageIQ::Providers::Lenovo::PhysicalInfraManager")

      # Hosts
      host_esx          = host_stub.create!(:type                  => "ManageIQ::Providers::Vmware::InfraManager::HostEsx",
                                            :ems_id => vmware_ems.id)
      host_esx_archived = host_stub.create!(:type                  => "ManageIQ::Providers::Vmware::InfraManager::HostEsx",
                                            :ems_id => nil)

      host_redhat = host_stub.create!(:type                  => "ManageIQ::Providers::Redhat::InfraManager::Host",
                                      :ems_id => redhat_ems.id)

      # Switches
      dvswitch               = switch_stub.create!(:name => "DVS", :uid_ems => "dvswitch-1", :shared => true,
                                                   :type => "ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch")
      dvswitch_without_assoc = switch_stub.create!(:name    => "DVS", :uid_ems => "dvswitch-3", :shared => true,
                                                   :host_id => host_esx.id,
                                                   :ems_id  => vmware_ems.id,
                                                   :type    => "ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch")
      dvswitch_archived    = switch_stub.create!(:name      => "DVS", :uid_ems => "dvswitch-1", :shared => true,
                                                 :ems_id    => vmware_ems.id,
                                                 :type      => "ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch")
      host_switch          = switch_stub.create!(:name => "vSwitch0", :uid_ems => "vSwitch0", :shared => false,
                                                 :type => "ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch")
      host_switch_archived = switch_stub.create!(:name      => "vSwitch0", :uid_ems => "vSwitch0",
                                                 :type      => "ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch")
      redhat_switch        = switch_stub.create!(:name => "vSwitch0", :uid_ems => "vSwitch0")
      physical_switch      = switch_stub.create!(:name      => "Physical Switch", :uid_ems => "switch-1",
                                                 :type      => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch",
                                                 :ems_id => lenovo_ems.id)
      physical_switch1     = switch_stub.create!(:name      => "Physical Switch", :uid_ems => "switch-1",
                                                 :type      => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch",
                                                 :ems_id => nil)
      # Host -> switches mapping
      host_switch_stub.create!(:host_id => host_esx.id, :switch_id => dvswitch.id)
      host_switch_stub.create!(:host_id => host_esx.id, :switch_id => host_switch.id)
      host_switch_stub.create!(:host_id => host_esx_archived.id, :switch_id => host_switch_archived.id)
      host_switch_stub.create!(:host_id => host_esx_archived.id, :switch_id => dvswitch_archived.id)
      host_switch_stub.create!(:host_id => host_redhat.id, :switch_id => redhat_switch.id)

      migrate

      expect(dvswitch.reload.ems_id).to eq(vmware_ems.id)
      expect(dvswitch.reload.host_id).to eq(nil)
      expect(dvswitch_archived.reload.ems_id).to eq(vmware_ems.id)
      expect(dvswitch_archived.reload.host_id).to eq(nil)
      expect(dvswitch_without_assoc.reload.ems_id).to eq(vmware_ems.id)
      expect(dvswitch_without_assoc.reload.host_id).to eq(host_esx.id)

      # All switches except ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch must stay the same
      expect(host_switch.reload.ems_id).to eq(nil)
      expect(host_switch.reload.host_id).to eq(host_esx.id)
      expect(host_switch_archived.reload.ems_id).to eq(nil)
      expect(host_switch_archived.reload.host_id).to eq(host_esx_archived.id)
      expect(redhat_switch.reload.ems_id).to eq(nil)
      expect(redhat_switch.reload.host_id).to eq(host_redhat.id)

      # Lenovo must be unaffected, since the switch relation is done a different way
      expect(physical_switch.reload.ems_id).to eq(lenovo_ems.id)
      expect(physical_switch.reload.host_id).to eq(nil)
      expect(physical_switch1.reload.ems_id).to eq(nil)
      expect(physical_switch1.reload.host_id).to eq(nil)
    end
  end
end
