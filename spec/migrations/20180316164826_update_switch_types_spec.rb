require_migration

describe UpdateSwitchTypes do
  let(:switch_stub)      { migration_stub(:Switch) }
  let(:host_stub)        { migration_stub(:Host) }

  migration_context :up do
    it "migrates a series of representative rows" do
      dvswitch        = switch_stub.create!(:name => "DVS", :uid_ems => "dvswitch-1", :shared => true)
      host_switch     = switch_stub.create!(:name => "vSwitch0", :uid_ems => "vSwitch0")
      physical_switch = switch_stub.create!(:name => "Physical Switch", :uid_ems => "switch-1",
                                            :type => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch")

      host_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::HostEsx").tap do |host|
        host.host_switches.create!(:host => host, :switch => dvswitch)
        host.host_switches.create!(:host => host, :switch => host_switch)
      end

      migrate

      expect(dvswitch.reload.type).to        eq("ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch")
      expect(host_switch.reload.type).to     eq("ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch")
      expect(physical_switch.reload.type).to eq("ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch")
    end
  end

  migration_context :down do
    it "migrates a series of representative rows" do
      dvswitch        = switch_stub.create!(:name => "DVS", :uid_ems => "dvswitch-1", :shared => true,
                                            :type => "ManageIQ::Providers::Vmware::InfraManager::DistributedVirtualSwitch")
      host_switch     = switch_stub.create!(:name => "vSwitch0", :uid_ems => "vSwitch0",
                                            :type => "ManageIQ::Providers::Vmware::InfraManager::HostVirtualSwitch")
      physical_switch = switch_stub.create!(:name => "Physical Switch", :uid_ems => "switch-1",
                                            :type => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch")

      migrate

      expect(dvswitch.reload.type).to        be_nil
      expect(host_switch.reload.type).to     be_nil
      expect(physical_switch.reload.type).to eq("ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalSwitch")
    end
  end
end
