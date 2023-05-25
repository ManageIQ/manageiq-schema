require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixVpcProvisionInstanceType do
  let(:vm_or_template_stub) { migration_stub(:VmOrTemplate) }
  let(:miq_request_stub)    { migration_stub(:MiqRequest) }

  migration_context :up do
    it "Fixes VPC provision requests" do
      vpc_template = vm_or_template_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template")
      request      = miq_request_stub.create!(:type => "MiqProvisionRequestTemplate", :source_type => "VmOrTemplate", :source_id => vpc_template.id, :options => {:provision_type => [1, "t2.micro"]})

      migrate

      request.reload

      expect(request.options[:instance_type]).to eq([1, "t2.micro"])
      expect(request.options).not_to             have_key(:provision_type)
    end

    it "Doesn't impact other provision requests" do
      vpc_template = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Vmware::InfraManager::Template")
      request      = miq_request_stub.create!(:type => "MiqProvisionRequestTemplate", :source_type => "VmOrTemplate", :source_id => vpc_template.id, :options => {:provision_type => ["pxe", "PXE"]})

      migrate

      request.reload

      expect(request.options[:provision_type]).to eq(["pxe", "PXE"])
    end
  end

  migration_context :down do
    it "Resets VPC provision requests" do
      vpc_template = vm_or_template_stub.create!(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template")
      request      = miq_request_stub.create!(:type => "MiqProvisionRequestTemplate", :source_type => "VmOrTemplate", :source_id => vpc_template.id, :options => {:instance_type => [1, "t2.micro"]})

      migrate

      request.reload

      expect(request.options[:provision_type]).to eq([1, "t2.micro"])
      expect(request.options).not_to              have_key(:instance_type)
    end

    it "Doesn't impact other provision requests" do
      vpc_template = vm_or_template_stub.create!(:type => "ManageIQ::Providers::Amazon::CloudManager::Template")
      request      = miq_request_stub.create!(:type => "MiqProvisionRequestTemplate", :source_type => "VmOrTemplate", :source_id => vpc_template.id, :options => {:instance_type => [1, "t2.micro"]})

      migrate

      request.reload

      expect(request.options[:instance_type]).to eq([1, "t2.micro"])
    end
  end
end
