require_migration

describe AddConversionHostIdToMiqRequestTasks do
  let(:task_stub) { migration_stub(:MiqRequestTask) }
  let(:host_stub) { migration_stub(:Host) }
  let(:conversion_host_stub) { migration_stub(:ConversionHost) }
  let(:host_id) { 42 }

  migration_context :up do
    it "when host doesn't exist" do
      task = task_stub.create!(
        :type    => 'ServiceTemplateTransformationPlanTask',
        :options => { :dummy_key => 'dummy_value', :transformation_host_id => host_id }
      )

      migrate
      task.reload

      expect(task.options).to eq({ :dummy_key => 'dummy_value', :transformation_host_id => host_id })
      expect(AddConversionHostIdToMiqRequestTasks::ConversionHost.find_by(:resource_id => host_id)).to be_nil
      expect(task.conversion_host).to be_nil
    end

    it "when host exist" do
      task = task_stub.create!(
        :type    => 'ServiceTemplateTransformationPlanTask',
        :options => { :dummy_key => 'dummy_value', :transformation_host_id => host_id }
      )
      host = host_stub.create!(:id => host_id)

      migrate
      task.reload

      expect(task.options).to eq({ :dummy_key => 'dummy_value' })
      expect(AddConversionHostIdToMiqRequestTasks::ConversionHost.find_by(:resource => host)).not_to be_nil
      expect(task.conversion_host).to eq(AddConversionHostIdToMiqRequestTasks::ConversionHost.find_by(:resource => host))
    end
  end

  migration_context :down do
    it "updates task.options" do
      host = host_stub.create!
      conversion_host = conversion_host_stub.create!(:resource => host)
      task = task_stub.create!(
        :type            => 'ServiceTemplateTransformationPlanTask',
        :conversion_host => conversion_host
      )

      migrate

      task.reload
      expect(task.options[:transformation_host_id]).to eq(host.id)
      expect { conversion_host.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
