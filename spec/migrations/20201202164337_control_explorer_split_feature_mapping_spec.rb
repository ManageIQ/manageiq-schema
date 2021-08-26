require_migration

describe ControlExplorerSplitFeatureMapping do
  let(:user_role_id) { id_in_current_region(1) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    describe 'product features renaming' do
      it 'renames the features' do
        ControlExplorerSplitFeatureMapping::FEATURE_MAPPING.keys.each do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        migrate

        ControlExplorerSplitFeatureMapping::FEATURE_MAPPING.values.each do |identifier|
          expect(feature_stub.find_by_identifier(identifier)).to be_truthy
        end
      end
    end
  end

  migration_context :down do
    describe 'product features revert' do
      it 'reverts the control explorer features' do
        ControlExplorerSplitFeatureMapping::FEATURE_MAPPING.values.each do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        migrate

        ControlExplorerSplitFeatureMapping::FEATURE_MAPPING.keys.each do |identifier|
          expect(feature_stub.find_by_identifier(identifier)).to be_truthy
        end
      end
    end
  end
end
