require_migration

describe AdjustChargebackRatesFeatures do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    describe 'product features update' do
      AdjustChargebackRatesFeatures::OLD_FEATURES.each do |identifier|
        context "feature #{identifier}" do
          it 'also sets the chargeback_rates_view feature' do
            feature = feature_stub.create!(:identifier => identifier)
            roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)

            migrate

            new_roles_feature = roles_feature_stub.where(:miq_user_role_id => user_role_id).where.not(:miq_product_feature_id => feature.id).first
            new_feature = feature_stub.find(new_roles_feature.miq_product_feature_id)
            expect(new_feature.identifier).to eq('chargeback_rates_view')
          end
        end
      end
    end
  end

  migration_context :down do
    describe 'product features update' do
      it 'sets the chargeback_rates_admin feature' do
        feature = feature_stub.create!(:identifier => 'chargeback_rates_admin')
        roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)

        migrate

        assigned = roles_feature_stub.where(:miq_user_role_id => user_role_id)
        expect(assigned.count).to eq(5)
      end
    end
  end
end
