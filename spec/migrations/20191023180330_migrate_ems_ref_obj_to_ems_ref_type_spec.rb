require_migration

describe MigrateEmsRefObjToEmsRefType do
  let(:cluster_stub)       { migration_stub(:EmsCluster) }
  let(:folder_stub)        { migration_stub(:EmsFolder) }
  let(:host_stub)          { migration_stub(:Host) }
  let(:resource_pool_stub) { migration_stub(:ResourcePool) }
  let(:storage_stub)       { migration_stub(:Storage) }
  let(:vm_stub)            { migration_stub(:VmOrTemplate) }

  migration_context :up do
    it "migrates ems_ref_obj to ems_ref_type" do
      vm = vm_stub.create!(
        :type        => "ManageIQ::Providers::Vmware::InfraManager::Vm",
        :ems_ref     => "vm-123",
        :ems_ref_obj => <<~EMS_REF_OBJ
          --- !ruby/string:VimString
          str: vm-1234
          xsiType: :ManagedObjectReference
          vimType: :VirtualMachine
        EMS_REF_OBJ
      )
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Vmware::InfraManager::HostEsx",
        :ems_ref     => "host-123",
        :ems_ref_obj => <<~EMS_REF_OBJ
          --- !ruby/string:VimString
          str: host-1234
          xsiType: :ManagedObjectReference
          vimType: :HostSystem
        EMS_REF_OBJ
      )
      cluster = cluster_stub.create!(
        :ems_ref     => "domain-c1234",
        :ems_ref_obj => <<~EMS_REF_OBJ
          --- !ruby/string:VimString
          str: domain-c1234
          xsiType: :ManagedObjectReference
          vimType: :ClusterComputeResource
        EMS_REF_OBJ
      )
      respool = resource_pool_stub.create!(
        :ems_ref     => "resgroup-1234",
        :ems_ref_obj => <<~EMS_REF_OBJ
          --- !ruby/string:VimString
          str: resgroup-1234
          xsiType: :ManagedObjectReference
          vimType: :ResourcePool
        EMS_REF_OBJ
      )
      storage = storage_stub.create!(
        :ems_ref     => "datastore-1234",
        :ems_ref_obj => <<~EMS_REF_OBJ
          --- !ruby/string:VimString
          str: datastore-1234
          xsiType: :ManagedObjectReference
          vimType: :Datastore
        EMS_REF_OBJ
      )

      migrate

      expect(vm.reload.ems_ref_type).to      eq("VirtualMachine")
      expect(host.reload.ems_ref_type).to    eq("HostSystem")
      expect(cluster.reload.ems_ref_type).to eq("ClusterComputeResource")
      expect(respool.reload.ems_ref_type).to eq("ResourcePool")
      expect(storage.reload.ems_ref_type).to eq("Datastore")
    end

    it "ignores ems_ref_obj if it isn't a VimString" do
      vm = vm_stub.create!(
        :type        => "ManageIQ::Providers::Redhat::InfraManager::Vm",
        :ems_ref     => "b7212ae9-e968-4431-bb17-cc16d5095cd0",
        :ems_ref_obj => "--- b7212ae9-e968-4431-bb17-cc16d5095cd0\n"
      )

      migrate

      expect(vm.reload.ems_ref_type).to be_nil
    end

    it "ignores ems_ref_obj if it is nil" do
      vm = vm_stub.create!(
        :type        => "ManageIQ::Providers::Amazon::CloudManager::Vm",
        :ems_ref     => "b7212ae9-e968-4431-bb17-cc16d5095cd0",
        :ems_ref_obj => nil,
        :cloud       => true
      )

      migrate

      vm.reload
      expect(vm.ems_ref_type).to be_nil
      expect(vm.ems_ref).to eq("b7212ae9-e968-4431-bb17-cc16d5095cd0")
    end
  end

  migration_context :down do
    it "migrates an ems_ref_type to an ems_ref_obj" do
      vm = vm_stub.create!(:ems_ref => "vm-1234", :ems_ref_type => "VirtualMachine")
      migrate
      expect(vm.reload.ems_ref_obj).to eq <<~EMS_REF_OBJ
        --- !ruby/string:VimString
        str: vm-1234
        xsiType: :ManagedObjectReference
        vimType: :VirtualMachine
      EMS_REF_OBJ
    end

    it "sets to a simple yaml string if ems_ref_type is nil" do
      vm = vm_stub.create!(:ems_ref => "b7212ae9-e968-4431-bb17-cc16d5095cd0")
      migrate
      expect(vm.reload.ems_ref_obj).to eq("--- b7212ae9-e968-4431-bb17-cc16d5095cd0\n")
    end

    it "ignores hosts that have ems_ref_obj set already" do
      host_instance_uuid = SecureRandom.uuid
      ems_ref_obj        = YAML.dump(host_instance_uuid)
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Openstack::InfraManager::Host",
        :ems_ref_obj => ems_ref_obj,
        :ems_ref     => "host-123"
      )

      migrate

      expect(host.reload.ems_ref_obj).to eq(ems_ref_obj)
    end

    it "ignores cloud vms" do
      vm = vm_stub.create!(
        :type        => "ManageIQ::Providers::Amazon::CloudManager::Vm",
        :ems_ref     => "b7212ae9-e968-4431-bb17-cc16d5095cd0",
        :ems_ref_obj => nil,
        :cloud       => true
      )

      migrate

      expect(vm.reload.ems_ref_obj).to be_nil
    end
  end
end
