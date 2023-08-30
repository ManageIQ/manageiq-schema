require_migration

describe DeleteNilTimestampEventStreams do
  let(:event_stream_stub) { migration_stub(:EventStream) }

  migration_context :up do
    it "removes nil timestamp events, leaving others" do
      good = event_stream_stub.create!(:timestamp => Time.now.utc)
      event_stream_stub.create!(:timestamp => nil)

      migrate

      expect(event_stream_stub.count).to eq(1)
      expect(event_stream_stub.first.id).to eq(good.id)
      expect(event_stream_stub.first.timestamp).to be_present
    end
  end
end
