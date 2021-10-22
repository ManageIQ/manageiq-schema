require_migration

describe RemoveMigrationFeature do
  migration_context :up do
    let(:service_template) { migration_stub(:ServiceTemplate) }
    let(:miq_request) { migration_stub(:MiqRequest) }
    let(:miq_request_task) { migration_stub(:MiqRequestTask) }
    let(:job) { migration_stub(:Job) }
    let(:conversion_host) { migration_stub(:ConversionHost) }
    let(:tag) { migration_stub(:Tag) }
    let(:tagging) { migration_stub(:Tagging) }
    let(:custom_attribute) { migration_stub(:CustomAttribute) }
    let(:vm) { migration_stub(:Vm) }
    let(:host) { migration_stub(:Host) }

    it "cleans the database and removes the tables" do
      service_template.create!(:type => "ServiceTemplate")
      service_template.create!(:type => "ServiceTemplateTransformationPlan")

      miq_request.create!(:type => "MiqRequest")
      miq_request.create!(:type => "ServiceTemplateTransformationPlanRequest")

      miq_request_task.create!(:type => "MiqRequestTask")
      miq_request_task.create!(:type => "ServiceTemplateTransformationPlanTask")

      job.create!(:type => "Job")
      job.create!(:type => "InfraConversionJob")

      tag_1 = tag.create!(:name => "/managed/v2v_transformation_host/false")
      tag_2 = tag.create!(:name => "/managed/v2v_transformation_host/true")
      tag_3 = tag.create!(:name => "/managed/v2v_transformation_method/vddk")
      tag_4 = tag.create!(:name => "/managed/v2v_transformation_method/ssh")
      tag_5 = tag.create!(:name => "/managed/stub/dummy")

      tagging.create!(:tag_id => tag_1.id)
      tagging.create!(:tag_id => tag_2.id)
      tagging.create!(:tag_id => tag_3.id)
      tagging.create!(:tag_id => tag_4.id)
      tagging.create!(:tag_id => tag_5.id)

      vm_1 = vm.create!(:type => "Vm")
      custom_attribute.create!(:resource_id => vm_1.id, :resource_type => "Vm", :name => "TransformationIPAddress", :value => "10.0.0.1")
      custom_attribute.create!(:resource_id => vm_1.id, :resource_type => "Vm", :name => "stub", :value => "dummy")
      conversion_host.create!(:resource_id => vm_1.id, :resource_type => "Vm")

      migrate

      expect(service_template.count).to eq(1)
      expect(service_template.first.type).to eq("ServiceTemplate")

      expect(miq_request.count).to eq(1)
      expect(miq_request.first.type).to eq("MiqRequest")

      expect(miq_request_task.count).to eq(1)
      expect(miq_request_task.first.type).to eq("MiqRequestTask")

      expect(job.count).to eq(1)
      expect(job.first.type).to eq("Job")

      expect(tag.count).to eq(1)
      expect(tag.first.name).to eq("/managed/stub/dummy")

      expect(tagging.count).to eq(1)
      expect(tagging.first.tag_id).to eq(tag_5.id)

      expect(custom_attribute.count).to eq(1)
      expect(custom_attribute.first.name).to eq("stub")
      expect(custom_attribute.first.value).to eq("dummy")
    end
  end
end
