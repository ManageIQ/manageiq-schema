require_migration

describe UpdatePlacementGroupViewFeatureIdentifier do
  let(:miq_product_feature_stub) { migration_stub(:MiqProductFeature) }

  migration_context :up do
    it "Update Placement Group '_list' feature to be '_view'" do
      miq_product_feature = miq_product_feature_stub.create(:identifier => 'placement_group_list')
      migrate
      expect(miq_product_feature.reload[:identifier]).to eq('placement_group_view')
    end
  end
  migration_context :down do
    it "Reset Placement Group '_view' feature back to '_list'" do
      miq_product_feature = miq_product_feature_stub.create(:identifier => 'placement_group_view')
      migrate
      expect(miq_product_feature.reload[:identifier]).to eq('placement_group_list')
    end
  end
end
