require_migration

class DropLogCollectionConfiguration < ActiveRecord::Migration[7.2]
  class MiqUserRole < ActiveRecord::Base; end
end

describe DropLogCollectionConfiguration do
  let(:miq_product_feature_stub) { migration_stub(:MiqProductFeature) }
  let(:miq_roles_feature_stub) { migration_stub(:MiqRolesFeature) }
  let(:miq_user_role_stub) { migration_stub(:MiqUserRole) }

  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "deletes product features" do
      features = described_class::FEATURE_NAMES.map do |feature|
        miq_product_feature_stub.find_or_create_by!(:identifier => feature)
      end
      features << miq_product_feature_stub.create!(:identifier => "other_feature")

      role = miq_user_role_stub.create!(:name => "role1")
      role_features = features.map do |f|
        miq_roles_feature_stub.create!(:miq_user_role_id => role.id, :miq_product_feature_id => f.id)
      end
      other_role_feature = role_features.last

      expect(miq_roles_feature_stub.count).to eq(features.length)

      migrate

      expect(miq_roles_feature_stub.count).to eq(1)
      expect(miq_roles_feature_stub.all).to eq([other_role_feature])
      expect(miq_product_feature_stub.where(:identifier => "other_feature").count).to eq(1)
      expect(miq_product_feature_stub.where(:identifier => "collect_logs").count).to eq(0)
    end

    it "deletes settings" do
      keep = settings_change_stub.create!(:key => "/log/level", :value => "debug")
      to_delete = settings_change_stub.create!(:key => "/log/collection/ping_depot", :value => "false")

      migrate

      expect(settings_change_stub.count).to eq(1)
      expect(settings_change_stub.first).to eq(keep)
    end
  end
end
