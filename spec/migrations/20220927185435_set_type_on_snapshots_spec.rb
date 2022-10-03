require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe SetTypeOnSnapshots do
  let(:ems_stub)      { migration_stub(:ExtManagementSystem) }
  let(:snapshot_stub) { migration_stub(:Snapshot) }
  let(:vm_stub)       { migration_stub(:VmOrTemplate) }

  migration_context :up do
    it "Sets Snapshot#type propertly" do
      powervs_ems      = ems_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager")
      powervs_vm       = vm_stub.create!(:type => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :ems_id => powervs_ems.id)
      powervs_snapshot = snapshot_stub.create!(:vm_or_template_id => powervs_vm.id)

      openstack_ems      = ems_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager")
      openstack_vm       = vm_stub.create!(:type => "ManageIQ::Providers::Openstack::CloudManager::Vm", :ems_id => openstack_ems.id)
      openstack_snapshot = snapshot_stub.create!(:vm_or_template_id => openstack_vm.id)

      powervc_ems      = ems_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager")
      powervc_vm       = vm_stub.create!(:type => "ManageIQ::Providers::IbmPowerVc::CloudManager::Vm", :ems_id => powervc_ems.id)
      powervc_snapshot = snapshot_stub.create!(:vm_or_template_id => powervc_vm.id)

      ibm_cic_ems      = ems_stub.create!(:type => "ManageIQ::Providers::IbmCic::CloudManager")
      ibm_cic_vm       = vm_stub.create!(:type => "ManageIQ::Providers::IbmCic::CloudManager::Vm", :ems_id => ibm_cic_ems.id)
      ibm_cic_snapshot = snapshot_stub.create!(:vm_or_template_id => ibm_cic_vm.id)

      scvmm_ems      = ems_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager")
      scvmm_vm       = vm_stub.create!(:type => "ManageIQ::Providers::Microsoft::InfraManager::Vm", :ems_id => scvmm_ems.id)
      scvmm_snapshot = snapshot_stub.create!(:vm_or_template_id => scvmm_vm.id)

      ovirt_ems      = ems_stub.create!(:type => "ManageIQ::Providers::Ovirt::InfraManager")
      ovirt_vm       = vm_stub.create!(:type => "ManageIQ::Providers::Ovirt::InfraManager::Vm", :ems_id => ovirt_ems.id)
      ovirt_snapshot = snapshot_stub.create!(:vm_or_template_id => ovirt_vm.id)

      rhv_ems      = ems_stub.create!(:type => "ManageIQ::Providers::Redhat::InfraManager")
      rhv_vm       = vm_stub.create!(:type => "ManageIQ::Providers::Redhat::InfraManager::Vm", :ems_id => rhv_ems.id)
      rhv_snapshot = snapshot_stub.create!(:vm_or_template_id => rhv_vm.id)

      vmware_ems      = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      vmware_vm       = vm_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Vm", :ems_id => vmware_ems.id)
      vmware_snapshot = snapshot_stub.create!(:vm_or_template_id => vmware_vm.id)

      migrate

      expect(powervs_snapshot.reload.type).to eq("#{powervs_ems.type}::Snapshot")
      expect(powervc_snapshot.reload.type).to eq("#{powervc_ems.type}::Snapshot")
      expect(openstack_snapshot.reload.type).to eq("#{openstack_ems.type}::Snapshot")
      expect(ibm_cic_snapshot.reload.type).to eq("#{ibm_cic_ems.type}::Snapshot")
      expect(scvmm_snapshot.reload.type).to eq("#{scvmm_ems.type}::Snapshot")
      expect(ovirt_snapshot.reload.type).to eq("#{ovirt_ems.type}::Snapshot")
      expect(rhv_snapshot.reload.type).to eq("#{rhv_ems.type}::Snapshot")
      expect(vmware_snapshot.reload.type).to eq("#{vmware_ems.type}::Snapshot")
    end
  end

  migration_context :down do
    it "Resets Snapshot#type to nil" do
      ems      = ems_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager")
      vm       = vm_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Vm", :ems_id => ems.id)
      snapshot = snapshot_stub.create!(:vm_or_template_id => vm.id)

      migrate

      expect(snapshot.reload.type).to be_nil
    end
  end
end
