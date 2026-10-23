require_migration

describe RenameFirmwareFeaturesAndGrantToRoles do
  let(:user_role_id)       { id_in_current_region(1) }
  let(:feature_stub)       { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    describe 'product features renaming and role assignment' do
      it 'renames firmware features to firmware_registry' do
        described_class::FEATURE_MAPPING.each_key do |identifier|
          feature_stub.create!(:identifier => identifier)
        end

        migrate

        described_class::FEATURE_MAPPING.each do |from, to|
          expect(feature_stub.exists?(:identifier => from)).to be_falsy
          expect(feature_stub.exists?(:identifier => to)).to be_truthy
        end
      end

      it 'grants binary and target features to roles that had firmware features' do
        described_class::FEATURE_MAPPING.each_key do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(4)

        migrate

        # 4 renamed registry features + 4 binary features + 4 target features = 12 total
        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(12)

        %w[
          firmware_registry firmware_registry_view firmware_registry_show_list firmware_registry_show
          firmware_binary firmware_binary_view firmware_binary_show_list firmware_binary_show
          firmware_target firmware_target_view firmware_target_show_list firmware_target_show
        ].each do |ident|
          feature = feature_stub.find_by(:identifier => ident)
          expect(feature).to be_truthy
          expect(roles_feature_stub.exists?(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)).to be_truthy
        end
      end
    end
  end

  migration_context :down do
    describe 'product features revert' do
      it 'reverts firmware_registry features back to firmware and removes new features/role mappings' do
        described_class::FEATURE_MAPPING.each_value do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        described_class::NEW_FEATURE_SETS.values.flatten.uniq.each do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(12)

        migrate

        # Binary and target features should be deleted along with their role assignments
        described_class::NEW_FEATURE_SETS.values.flatten.uniq.each do |identifier|
          expect(feature_stub.exists?(:identifier => identifier)).to be_falsy
        end

        # Registry features should be reverted back to generic firmware
        described_class::FEATURE_MAPPING.each do |from, to|
          expect(feature_stub.exists?(:identifier => to)).to be_falsy
          expect(feature_stub.exists?(:identifier => from)).to be_truthy
        end

        expect(roles_feature_stub.where(:miq_user_role_id => user_role_id).count).to eq(4)
      end
    end
  end
end
