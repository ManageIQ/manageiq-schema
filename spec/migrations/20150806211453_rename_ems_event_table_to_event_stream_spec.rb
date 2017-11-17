require_migration

describe RenameEmsEventTableToEventStream do
  let(:ems_event_stub)      { migration_stub(:EmsEvent) }
  let(:event_stream_stub)   { migration_stub(:EventStream) }

  migration_context :up do
    it 'adds two columns' do
      ems_event_stub.create!

      migrate

      event_stream = event_stream_stub.first
      expect(event_stream.type).to eq('EmsEvent')
      expect(event_stream.target_id).to be_nil
    end

    it 'updates in batches' do
      stub_const("#{described_class}::BATCH_SIZE", 5)

      ems_event_stub.transaction do
        14.times { ems_event_stub.create! }
      end

      migrate

      expect(event_stream_stub.distinct.pluck(:type)).to      eq ["EmsEvent"]
      expect(event_stream_stub.distinct.pluck(:target_id)).to eq [nil]
    end
  end

  migration_context :down do
    it 'deletes two columns' do
      event_stream_stub.create!

      migrate

      event = ems_event_stub.first
      expect(event).not_to respond_to(:type)
      expect(event).not_to respond_to(:target_id)
    end
  end
end
