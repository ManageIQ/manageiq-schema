require_migration

describe FixIbmPowerVcStiClasses do
  let(:ems_stub)                   { migration_stub(:ExtManagementSystem) }
  let(:cloud_network_stub)         { migration_stub(:CloudNetwork) }
  let(:cloud_subnet_stub)          { migration_stub(:CloudSubnet) }
  let(:floating_ip_stub)           { migration_stub(:FloatingIp) }
  let(:network_port_stub)          { migration_stub(:NetworkPort) }
  let(:network_router_stub)        { migration_stub(:NetworkRouter) }
  let(:security_group_stub)        { migration_stub(:SecurityGroup) }
  let(:cloud_volume_stub)          { migration_stub(:CloudVolume) }
  let(:cloud_volume_backup_stub)   { migration_stub(:CloudVolumeBackup) }
  let(:cloud_volume_snapshot_stub) { migration_stub(:CloudVolumeSnapshot) }
  let(:cloud_volume_type_stub)     { migration_stub(:CloudVolumeType) }

  migration_context :up do
    it "Fixes IBM PowerVC Network STI classes" do
      ibm_power_vc_network_klass = "ManageIQ::Providers::IbmPowerVc::NetworkManager"
      openstack_network_klass = "ManageIQ::Providers::Openstack::NetworkManager"

      network_manager = ems_stub.create(:type => ibm_power_vc_network_klass)

      cloud_network         = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{openstack_network_klass}::CloudNetwork")
      cloud_network_public  = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{openstack_network_klass}::CloudNetwork::Public")
      cloud_network_private = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{openstack_network_klass}::CloudNetwork::Private")
      cloud_subnet          = cloud_subnet_stub.create(:ems_id => network_manager.id)
      floating_ip           = floating_ip_stub.create(:ems_id => network_manager.id)
      network_port          = network_port_stub.create(:ems_id => network_manager.id)
      network_router        = network_router_stub.create(:ems_id => network_manager.id)
      security_group        = security_group_stub.create(:ems_id => network_manager.id)

      migrate

      expect(cloud_network.reload.type).to         eq("#{ibm_power_vc_network_klass}::CloudNetwork")
      expect(cloud_network_public.reload.type).to  eq("#{ibm_power_vc_network_klass}::CloudNetwork::Public")
      expect(cloud_network_private.reload.type).to eq("#{ibm_power_vc_network_klass}::CloudNetwork::Private")
      expect(cloud_subnet.reload.type).to          eq("#{ibm_power_vc_network_klass}::CloudSubnet")
      expect(floating_ip.reload.type).to           eq("#{ibm_power_vc_network_klass}::FloatingIp")
      expect(network_port.reload.type).to          eq("#{ibm_power_vc_network_klass}::NetworkPort")
      expect(network_router.reload.type).to        eq("#{ibm_power_vc_network_klass}::NetworkRouter")
      expect(security_group.reload.type).to        eq("#{ibm_power_vc_network_klass}::SecurityGroup")
    end

    it "Fixes IBM PowerVC Storage (Cinder) STI classes" do
      ibm_power_vc_cinder_klass = "ManageIQ::Providers::IbmPowerVc::StorageManager::CinderManager"

      cinder_manager = ems_stub.create(:type => ibm_power_vc_cinder_klass)

      cloud_volume          = cloud_volume_stub.create(:ems_id => cinder_manager.id)
      cloud_volume_backup   = cloud_volume_backup_stub.create(:ems_id => cinder_manager.id)
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create(:ems_id => cinder_manager.id)
      cloud_volume_type     = cloud_volume_type_stub.create(:ems_id => cinder_manager.id)

      migrate

      expect(cloud_volume.reload.type).to          eq("#{ibm_power_vc_cinder_klass}::CloudVolume")
      expect(cloud_volume_backup.reload.type).to   eq("#{ibm_power_vc_cinder_klass}::CloudVolumeBackup")
      expect(cloud_volume_snapshot.reload.type).to eq("#{ibm_power_vc_cinder_klass}::CloudVolumeSnapshot")
      expect(cloud_volume_type.reload.type).to     eq("#{ibm_power_vc_cinder_klass}::CloudVolumeType")
    end
  end

  migration_context :down do
    it "Resets IBM PowerVC Network STI classes" do
      ibm_power_vc_network_klass = "ManageIQ::Providers::IbmPowerVc::NetworkManager"
      openstack_network_klass = "ManageIQ::Providers::Openstack::NetworkManager"

      network_manager = ems_stub.create(:type => ibm_power_vc_network_klass)

      cloud_network         = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::CloudNetwork")
      cloud_network_public  = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::CloudNetwork::Public")
      cloud_network_private = cloud_network_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::CloudNetwork::Private")
      cloud_subnet          = cloud_subnet_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::CloudSubnet")
      floating_ip           = floating_ip_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::FloatingIp")
      network_port          = network_port_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::NetworkPort")
      network_router        = network_router_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::NetworkRouter")
      security_group        = security_group_stub.create(:ems_id => network_manager.id, :type => "#{ibm_power_vc_network_klass}::SecurityGroup")

      migrate

      expect(cloud_network.reload.type).to         eql("#{openstack_network_klass}::CloudNetwork")
      expect(cloud_network_public.reload.type).to  eql("#{openstack_network_klass}::CloudNetwork::Public")
      expect(cloud_network_private.reload.type).to eql("#{openstack_network_klass}::CloudNetwork::Private")
      expect(cloud_subnet.reload.type).to          eql("#{openstack_network_klass}::CloudSubnet")
      expect(floating_ip.reload.type).to           eql("#{openstack_network_klass}::FloatingIp")
      expect(network_port.reload.type).to          eql("#{openstack_network_klass}::NetworkPort")
      expect(network_router.reload.type).to        eql("#{openstack_network_klass}::NetworkRouter")
      expect(security_group.reload.type).to        eql("#{openstack_network_klass}::SecurityGroup")
    end

    it "Resets IBM PowerVC Storage (Cinder) STI classes" do
      ibm_power_vc_cinder_klass = "ManageIQ::Providers::IbmPowerVc::StorageManager::CinderManager"
      openstack_cinder_klass = "ManageIQ::Providers::Openstack::StorageManager::CinderManager"

      cinder_manager = ems_stub.create(:type => ibm_power_vc_cinder_klass)

      cloud_volume = cloud_volume_stub.create(:ems_id => cinder_manager.id, :type => "#{ibm_power_vc_cinder_klass}::CloudVolume")
      cloud_volume_backup = cloud_volume_backup_stub.create(:ems_id => cinder_manager.id, :type => "#{ibm_power_vc_cinder_klass}::CloudVolumeBackup")
      cloud_volume_snapshot = cloud_volume_snapshot_stub.create(:ems_id => cinder_manager.id, :type => "#{ibm_power_vc_cinder_klass}::CloudVolumeSnapshot")
      cloud_volume_type = cloud_volume_type_stub.create(:ems_id => cinder_manager.id, :type => "#{ibm_power_vc_cinder_klass}::CloudVolumeType")

      migrate

      expect(cloud_volume.reload.type).to          eql("#{openstack_cinder_klass}::CloudVolume")
      expect(cloud_volume_backup.reload.type).to   eql("#{openstack_cinder_klass}::CloudVolumeBackup")
      expect(cloud_volume_snapshot.reload.type).to eql("#{openstack_cinder_klass}::CloudVolumeSnapshot")
      expect(cloud_volume_type.reload.type).to     eql("#{openstack_cinder_klass}::CloudVolumeType")
    end
  end
end
