require_migration

describe UpdateResourcePoolFeaturesForInfra do
  let(:feature_stub) { migration_stub(:MiqProductFeature) }

  migration_context :up do
    it 'renames resource pool features to infrastructure' do
      features = {}
      UpdateResourcePoolFeaturesForInfra::INFRA_FEATURE_MAPPING.each do |before, _|
        features[before] = feature_stub.create!(identifier: before)
      end

      migrate

      UpdateResourcePoolFeaturesForInfra::INFRA_FEATURE_MAPPING.each do |before, after|
        updated_feature = features[before].reload
        expect(updated_feature.identifier).to eq(after)
      end
    end
  end

  migration_context :down do
    it 'reverts infrastructure resource pool features to original' do
      features = {}
      UpdateResourcePoolFeaturesForInfra::INFRA_FEATURE_MAPPING.each do |_, after|
        features[after] = feature_stub.create!(identifier: after)
      end

      migrate

      UpdateResourcePoolFeaturesForInfra::INFRA_FEATURE_MAPPING.each do |before, after|
        reverted_feature = features[after].reload
        expect(reverted_feature.identifier).to eq(before)
      end
    end
  end
end
