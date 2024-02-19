require_migration

describe Updateresourcepoolidentifierstomiqproductfeatures do
  let(:miq_product_feature) { migration_stub(:MiqProductFeature) }

  before do
    %w[resource_pool resource_pool_view resource_pool_show_list resource_pool_show resource_pool_control resource_pool_tag resource_pool_protect resource_pool_admin resource_pool_delete].each do |identifier|
      miq_product_feature.create!(:identifier => identifier)
    end
  end

  migration_context :up do
    it "updates existing resource_pool features to resource_pool_infra" do
      migrate

      described_class::FEATURE_MAPPING_UPDATE.each do |old_identifier, new_identifier|
        expect(miq_product_feature.exists?(:identifier => old_identifier)).to be_falsy
        expect(miq_product_feature.exists?(:identifier => new_identifier)).to be_truthy
      end
    end
  end

  migration_context :down do
    before do
      described_class::FEATURE_MAPPING_UPDATE.each do |_old_identifier, new_identifier|
        miq_product_feature.create!(:identifier => new_identifier)
      end
    end

    it "reverts resource_pool_infra features back to resource_pool" do
      migrate

      described_class::FEATURE_MAPPING_UPDATE.each do |old_identifier, new_identifier|
        expect(miq_product_feature.exists?(:identifier => new_identifier)).to be_falsy
        expect(miq_product_feature.exists?(:identifier => old_identifier)).to be_truthy
      end
    end
  end
end
