require_migration

class UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker
  class MiqRolesFeature < ActiveRecord::Base; end
end

describe UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    describe 'product features update' do
      it "renamed features aren't removed from user roles" do
        features = {}
        UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker::FEATURE_MAPPING.each do |before, _|
          features[before] = feature_stub.create!(:identifier => before)
          roles_feature_stub.create!(:miq_product_feature_id => features[before].id, :miq_user_role_id => user_role_id)
        end

        migrate

        UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker::FEATURE_MAPPING.each do |before, after|
          after_feature = features[before].reload
          expect(after_feature.identifier).to eq(after)
        end
        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(features.keys.length)
      end
    end
  end

  migration_context :down do
    describe 'product features update' do
      it "renamed features aren't removed from user roles" do
        features = {}
        UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker::FEATURE_MAPPING.each do |_, after|
          features[after] = feature_stub.create!(:identifier => after)
          roles_feature_stub.create!(:miq_product_feature_id => features[after].id, :miq_user_role_id => user_role_id)
        end

        migrate

        UpdateProductFeaturesWhereIdentifierWasRenamedSinceLasker::FEATURE_MAPPING.each do |before, after|
          before_feature = features[after].reload
          expect(before_feature.identifier).to eq(before)
        end
        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(features.keys.length)
      end
    end
  end
end
