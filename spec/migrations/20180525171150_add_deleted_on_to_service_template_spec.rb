require_migration

describe AddDeletedOnToServiceTemplate do
  let(:reserve_stub)          { Spec::Support::MigrationStubs.reserved_stub }
  let(:service_template_stub) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "Migrates Reserve data to ServiceTemplate" do
      deleted_on_time = Time.current

      st = service_template_stub.create!
      reserve_stub.create!(
        :resource_type => st.class.name,
        :resource_id   => st.id,
        :reserved      => {
          :deleted_on => deleted_on_time,
        }
      )

      migrate

      st.reload

      expect(reserve_stub.count).to eq(0)
      expect(st.deleted_on.to_s).to eq(deleted_on_time.to_s)
    end
  end

  migration_context :down do
    it "Migrates deleted_on in ServiceTemplate to Reserve table" do
      deleted_on_time = Time.current

      st = service_template_stub.create!(
        :deleted_on => deleted_on_time,
      )

      migrate

      expect(reserve_stub.count).to eq(1)

      reserved_rec = reserve_stub.first
      expect(reserved_rec.resource_id).to   eq(st.id)
      expect(reserved_rec.resource_type).to eq(st.class.name)

      expect(reserved_rec.reserved[:deleted_on].to_s).to eq(deleted_on_time.to_s)
    end
  end
end
