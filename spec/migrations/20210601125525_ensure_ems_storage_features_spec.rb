require_migration

RSpec.describe EnsureEmsStorageFeatures do
  migration_context :up do
    let(:user_role_stub) { migration_stub(:MiqUserRole) }
    let(:product_feature_stub) { migration_stub(:MiqProductFeature) }
    let!(:ems_block_storage_view) do
      product_feature_stub.create!(
        :name         => "View",
        :description  => "View Block Storage Managers",
        :feature_type => "view",
        :identifier   => "ems_block_storage_view"
      )
    end

    let!(:ems_object_storage_view) do
      product_feature_stub.create!(
        :name         => "View",
        :description  => "View Object Storage Managers",
        :feature_type => "view",
        :identifier   => "ems_object_storage_view"
      )
    end

    let!(:ems_storage_view) do
      product_feature_stub.create!(
        :name         => "View",
        :description  => "View Storage Managers",
        :feature_type => "view",
        :identifier   => "ems_storage_view"
      )
    end

    it "adds ems_storage* feature if ems_block_storage* feature is enabled" do
      user_role = user_role_stub.create!(
        :miq_product_feature_ids => [ems_block_storage_view.id],
        :read_only            => false
      )

      migrate

      expect(user_role.reload.miq_product_feature_ids).to include(ems_storage_view.id)
    end

    it "adds ems_storage* feature if ems_object_storage* feature is enabled" do
      user_role = user_role_stub.create!(
        :miq_product_feature_ids => [ems_object_storage_view.id],
        :read_only            => false
      )

      migrate

      expect(user_role.reload.miq_product_feature_ids).to include(ems_storage_view.id)
    end

    it "doesn't duplicate if ems_storage* feature already enabled" do
      user_role = user_role_stub.create!(
        :miq_product_feature_ids => [ems_block_storage_view.id, ems_object_storage_view.id, ems_storage_view.id],
        :read_only            => false
      )

      expect(user_role.miq_product_feature_ids).to match_array([ems_storage_view.id, ems_object_storage_view.id, ems_block_storage_view.id])

      migrate

      expect(user_role.reload.miq_product_feature_ids).to match_array([ems_storage_view.id, ems_object_storage_view.id, ems_block_storage_view.id])
    end

    it "skips user roles without any ems_(block|object)_storage* features" do
      ems_cloud_view = product_feature_stub.create!(
        :name         => "View",
        :description  => "View Cloud Managers",
        :feature_type => "view",
        :identifier   => "ems_cloud_view"
      )

      user_role = user_role_stub.create!(
        :miq_product_feature_ids => [ems_cloud_view.id],
        :read_only            => false
      )

      migrate

      expect(user_role.reload.miq_product_feature_ids).to match_array([ems_cloud_view.id])
    end
  end
end
