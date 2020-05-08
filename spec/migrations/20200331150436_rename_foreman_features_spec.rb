require_migration

describe RenameForemanFeatures do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }
  let(:user_stub) { migration_stub :User }

  migration_context :up do
    describe 'product features update' do
      it 'renames the features' do
        accord_feature = feature_stub.create!(:identifier => 'providers_accord')
        view_feature = feature_stub.create!(:identifier => 'provider_foreman_view')

        migrate

        expect(accord_feature.reload.identifier).to eq('ems_configuration')
        expect(view_feature.reload.identifier).to eq('ems_configuration_view')
      end

      it 'appends the extra features for roles' do
        %w[ems_configuration configured_system configuration_profile].each do |feature|
          feature_stub.create!(:identifier => feature)
        end

        explorer_feature = feature_stub.create!(:identifier => 'provider_foreman_explorer')
        roles_feature_stub.create!(:miq_product_feature_id => explorer_feature.id, :miq_user_role_id => user_role_id)

        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(1)

        migrate

        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(4)
      end
    end

    describe 'starting page replace' do
      it 'replaces user starting page if foreman' do
        feature_stub.create!(:identifier => 'provider_foreman_explorer')
        user = user_stub.create!(:settings => {:display => {:startpage => 'provider_foreman/explorer'}})

        migrate
        user.reload

        expect(user.settings[:display][:startpage]).to eq('ems_configuration/show_list')
      end
    end

    it 'does not affect users without settings' do
      user = user_stub.create!

      migrate

      expect(user_stub.find(user.id)).to eq(user)
    end
  end

  migration_context :down do
    let!(:explorer_feature) { feature_stub.create!(:identifier => 'ems_configuration') }
    let!(:view_feature) { feature_stub.create!(:identifier => 'ems_configuration_view') }

    describe 'product features update' do
      it 'renames the features' do
        migrate

        expect(explorer_feature.reload.identifier).to eq('providers_accord')
        expect(view_feature.reload.identifier).to eq('provider_foreman_view')
      end
    end

    describe 'starting page replace' do
      %w[ems_configuration/show_list configuration_profile/show_list configured_system/show_list].each do |page|
        it "replaces user starting page to foreman if #{page}" do
          user = user_stub.create!(:settings => {:display => {:startpage => page}})

          migrate
          user.reload

          expect(user.settings[:display][:startpage]).to eq('provider_foreman/explorer')
        end
      end

      it 'does not affect users without settings' do
        user = user_stub.create!

        migrate

        expect(user_stub.find(user.id)).to eq(user)
      end
    end
  end
end
