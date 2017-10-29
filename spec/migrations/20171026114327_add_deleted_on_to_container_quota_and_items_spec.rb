require_migration

describe AddDeletedOnToContainerQuotaAndItems do
  let(:container_quota_stub) { migration_stub(:ContainerQuota) }
  let(:container_quota_item_stub) { migration_stub(:ContainerQuotaItem) }

  let(:quota_data) do
    {
      :name             => "compute-resources",
      # This is a real example, quota existed in openshift 2 month before
      # provider was even added and refresh created DB record.
      :created_on       => "2017-10-19 09:07:28 UTC",
      :ems_created_on   => "2017-08-09 11:56:21 UTC",
      :ems_ref          => "c2a9805e-7cf9-11e7-8ac6-001a4a162683",
      :resource_version => "5553729",
      # omitted ems_id, container_project_id.
    }
  end
  let(:item_data) do
    {
      :resource       => "cpu",
      :quota_desired  => 0.02,
      :quota_enforced => 0.02,
      :quota_observed => 0.0,
    }
  end

  migration_context :up do
    it "works with a container_quota_item" do
      quota = container_quota_stub.create!(quota_data)
      item = container_quota_item_stub.create!(:container_quota_id => quota.id, **item_data)

      migrate
      item.reload

      expect(item.created_at).to eq(quota.created_on)
      expect(item.updated_at).not_to eq(nil)
    end

    # really improbable but just in case
    it "works with an item whose quota.created_on is null" do
      quota = container_quota_stub.create!(quota_data)
      quota.update_columns(:created_on => nil)
      expect(quota.reload.created_on).to eq(nil) # verify we convinced rails to clear the timestamp

      item = container_quota_item_stub.create!(:container_quota_id => quota.id, **item_data)

      migrate
      item.reload

      expect(item.deleted_on).to eq(nil)
      expect(item.created_at).not_to eq(nil)
      expect(item.updated_at).not_to eq(nil)
    end

    it "works with an orphan item that has no parent quota" do
      item = container_quota_item_stub.create!(:container_quota_id => nil, **item_data)

      migrate
      item.reload

      expect(item.deleted_on).to eq(nil)
      expect(item.created_at).not_to eq(nil)
      expect(item.updated_at).not_to eq(nil)
    end
  end

  migration_context :down do
    let(:quota_data_with_timestamps) do
      quota_data.merge(:deleted_on => "2017-11-15 15:55:55 UTC")
    end
    let(:item_data_with_timestamps) do
      item_data.merge(:created_at => "2017-10-21 11:11:11 UTC",
                      :updated_at => "2017-10-22 22:22:22 UTC",
                      :deleted_on => "2017-10-23 23:33:33 UTC")
    end

    it "works with a container_quota_item" do
      quota = container_quota_stub.create!(quota_data_with_timestamps)
      container_quota_item_stub.create!(:container_quota_id => quota.id, **item_data_with_timestamps)

      migrate
    end

    it "works with an item whose quota.created_on is null" do
      quota = container_quota_stub.create!(quota_data_with_timestamps)
      quota.update_columns(:created_on => nil)
      expect(quota.reload.created_on).to eq(nil) # verify we convinced rails to clear the timestamp

      container_quota_item_stub.create!(:container_quota_id => quota.id, **item_data_with_timestamps)

      migrate
    end

    it "works with an orphan item that has no parent quota" do
      container_quota_item_stub.create!(:container_quota_id => nil, **item_data_with_timestamps)

      migrate
    end
  end
end
