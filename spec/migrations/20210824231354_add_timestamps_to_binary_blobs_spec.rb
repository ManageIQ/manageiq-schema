require_migration

describe AddTimestampsToBinaryBlobs do
  let(:binary_blob_stub) { new_migration_stub(:binary_blobs) }

  migration_context :up do
    it "adds timestamp columns and auto-populates the value" do
      record = binary_blob_stub.create!
      expect(record.respond_to?(:created_at)).to be false
      expect(record.respond_to?(:updated_at)).to be false

      before_migration_time = 5.seconds.ago.utc

      migrate

      record.reload
      expect(record.created_at).to be > before_migration_time
      expect(record.updated_at).to be > before_migration_time
    end
  end

  migration_context :down do
    it "removes timestamp columns" do
      before_migration_time = 5.seconds.ago.utc

      record = binary_blob_stub.create!

      expect(record.created_at).to be > before_migration_time
      expect(record.updated_at).to be > before_migration_time

      migrate

      record.reload
      expect(record.respond_to?(:created_at)).to be false
      expect(record.respond_to?(:updated_at)).to be false
    end
  end
end
