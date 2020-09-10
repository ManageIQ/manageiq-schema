require_migration

describe AdjustControlExplorerFeatures do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }

  migration_context :up do
    describe 'product features update' do
      it 'updates the control feature' do
        AdjustControlExplorerFeatures::FEATURE_MAPPING.keys.each do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
        end

        migrate

        feature = feature_stub.find_by(:identifier => 'control')
        expect(feature.identifier).to eq('control')
      end

      it 'renames the features' do
        view_feature = feature_stub.create!(:identifier => 'control_explorer')

        migrate

        expect(view_feature.reload.identifier).to eq('control')
      end
    end
  end

  migration_context :down do
    let!(:view_feature) { feature_stub.create!(:identifier => 'control') }

    describe 'product features update' do
      it 'sets the control feature back to unified control_explorer feature' do
        migrate

        expect(view_feature.reload.identifier).to eq('control_explorer')
      end
    end
  end
end
