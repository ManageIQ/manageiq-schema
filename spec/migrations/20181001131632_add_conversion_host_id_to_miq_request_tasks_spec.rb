require_migration

describe AddConversionHostIdToMiqRequestTasks do
  let(:task_stub) { migration_stub(:MiqRequestTask) }
  let(:host_stub) { migration_stub(:Host) }
  let(:conversion_host_stub) { migration_stub(:ConversionHost) }

  migration_context :up do
    it "creates conversion host" do
      task = task_stub.create!
      host = host_stub.create!
      conversion_host = conversion_host_stub.create!(
        :resource_id   => host.id,
        :resource_type => host.type
      )
      task.options = { :transformation_host_id => conversion_host.id }
      task.save

      migrate

      task.reload
      expect(task.options).to eq({})
      expect(task.conversion_host).to eq(conversion_host)
    end
  end

  migration_context :down do
    it "updates task.options" do
      task = task_stub.create!
      host = host_stub.create!
      conversion_host = conversion_host_stub.create!(
        :resource_id   => host.id,
        :resource_type => host.type
      )
      conversion_host.save
      task.conversion_host = conversion_host
      task.save

      migrate

      task.reload
      expect(task.attributes).not_to include('conversion_host_id')
      expect(task.options[:transformation_host_id]).to eq(conversion_host.id)
      expect { conversion_host.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
