require_migration

describe MoveEmsRefreshArgsToData do
  let(:miq_queue_stub) { migration_stub(:MiqQueue) }
  let(:targets) { [['Vm', 1], ['Host', 2]] }
  let(:refresh_queue_options) do
    {
      :class_name  => 'EmsRefresh',
      :method_name => 'refresh',
      :role        => 'ems_inventory',
      :queue_name  => 'ems_1',
      :zone        => 'default',
    }
  end
  let(:refresh_new_target_queue_options) do
    {
      :class_name  => 'EmsRefresh',
      :method_name => 'refresh_new_target',
      :role        => 'ems_inventory',
      :queue_name  => 'ems_1',
      :zone        => 'default',
    }
  end

  migration_context :up do
    it "Moves EmsRefresh.refresh queue args to data" do
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:args => [targets]))

      migrate

      expect(Marshal.load(q_item.reload.msg_data)).to match_array(targets)
    end

    it "Leaves EmsRefresh.refresh args empty" do
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:args => [targets]))

      migrate

      expect(q_item.reload.args).to match_array([])
    end

    it "Ignores unrelated queue items" do
      args = [{:ems_ref => "vm-123"}]
      q_item = miq_queue_stub.create!(refresh_new_target_queue_options.merge(:args => args))

      migrate

      expect(q_item.reload.args).to match_array(args)
    end
  end

  migration_context :down do
    it "Moves EmsRefresh.refresh data to args" do
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:msg_data => Marshal.dump(targets)))

      migrate

      expect(q_item.reload.args).to match_array(targets)
    end

    it "If there are no args" do
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:msg_data => nil))

      migrate

      expect(q_item.reload.args).to match_array([])
    end

    it "Handle invalid marshal format errors" do
      # "\x03\x00\x00" is an empty array in Marshal version 3.0
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:msg_data => "\x03\x00\x00"))

      migrate

      expect { q_item.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "Deletes invalid queue items but migrates the rest" do
      # "\x03\x00\x00" is an empty array in Marshal version 3.0
      miq_queue_stub.create!(refresh_queue_options.merge(:msg_data => "\x03\x00\x00"))
      q_item = miq_queue_stub.create!(refresh_queue_options.merge(:msg_data => Marshal.dump(targets)))

      migrate

      expect(q_item.reload.args).to match_array(targets)
    end
  end
end
