require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe ResetResourcePoolIdentifiers do
  let(:miq_product_feature) { migration_stub(:MiqProductFeature) }

  before do
    described_class::FEATURE_MAPPING_UPDATE.each_key do |old_identifier|
      miq_product_feature.create!(:identifier => old_identifier)
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
      described_class::FEATURE_MAPPING_UPDATE.each_value do |new_identifier|
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
