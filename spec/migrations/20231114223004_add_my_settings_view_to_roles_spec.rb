require_migration

describe AddMySettingsViewToRoles do
  migration_context :up do
    let(:user_role_stub)       { migration_stub(:MiqUserRole) }
    let(:product_feature_stub) { migration_stub(:MiqProductFeature) }

    let!(:my_settings_base)  { product_feature_stub.create!(:feature_type => "node", :identifier => "my_settings") }
    let!(:my_settings_other) { product_feature_stub.create!(:feature_type => "admin", :identifier => "my_settings_visuals", :parent_id => my_settings_base.id) }

    let(:my_settings_view) do
      product_feature_stub
        .create_with(:feature_type => "view", :identifier => "my_settings_view", :parent_id => my_settings_base.id)
        .find_or_create_by(:identifier => "my_settings_view")
    end

    let!(:seeded_user_role) { user_role_stub.create!(:miq_product_features => [my_settings_other], :read_only => true) }

    it "does nothing if there aren't any custom user roles" do
      migrate

      expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged
      expect(product_feature_stub.where(:identifier => "my_settings_view")).to_not exist
    end

    it "updates custom user roles with a my_settings_* feature" do
      custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_other], :read_only => false)

      migrate

      custom_user_role.reload
      seeded_user_role.reload
      expect(custom_user_role.miq_product_features).to match_array([my_settings_other, my_settings_view])
      expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

      expect(product_feature_stub.where(:identifier => "my_settings_view")).to exist
      expect(product_feature_stub.where(:identifier => "my_settings_view")).to match_array([my_settings_view])
    end

    it "skips custom user roles with the base my_settings feature" do
      custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_base], :read_only => false)

      migrate

      custom_user_role.reload
      seeded_user_role.reload
      expect(custom_user_role.miq_product_features).to match_array([my_settings_base]) # unchanged
      expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

      expect(product_feature_stub.where(:identifier => "my_settings_view")).to_not exist
    end

    it "skips custom user roles with the base my_settings feature and a my_settings_* feature" do # This edge case should not exist, but we handle it anyway
      custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_base, my_settings_other], :read_only => false)

      migrate

      custom_user_role.reload
      seeded_user_role.reload
      expect(custom_user_role.miq_product_features).to match_array([my_settings_base, my_settings_other]) # unchanged
      expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

      expect(product_feature_stub.where(:identifier => "my_settings_view")).to_not exist
    end

    context "when my_settings_view already exists" do
      before { my_settings_view }

      it "updates custom user roles with a my_settings_* feature" do
        custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_other], :read_only => false)

        migrate

        custom_user_role.reload
        seeded_user_role.reload
        expect(custom_user_role.miq_product_features).to match_array([my_settings_other, my_settings_view])
        expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

        expect(product_feature_stub.where(:identifier => "my_settings_view")).to match_array([my_settings_view])
      end

      it "handles custom user roles with a my_settings_* feature and already have my_settings_view" do
        custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_other, my_settings_view], :read_only => false)

        migrate

        custom_user_role.reload
        seeded_user_role.reload
        expect(custom_user_role.miq_product_features).to match_array([my_settings_other, my_settings_view]) # unchanged
        expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

        expect(product_feature_stub.where(:identifier => "my_settings_view")).to match_array([my_settings_view])
      end

      it "skips custom user roles with the base my_settings feature" do
        custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_base], :read_only => false)

        migrate

        custom_user_role.reload
        seeded_user_role.reload
        expect(custom_user_role.miq_product_features).to match_array([my_settings_base]) # unchanged
        expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

        expect(product_feature_stub.where(:identifier => "my_settings_view")).to match_array([my_settings_view])
      end

      it "skips custom user roles with the base my_settings feature and a my_settings_* feature" do # This edge case should not exist, but we handle it anyway
        custom_user_role = user_role_stub.create!(:miq_product_features => [my_settings_base, my_settings_other], :read_only => false)

        migrate

        custom_user_role.reload
        seeded_user_role.reload
        expect(custom_user_role.miq_product_features).to match_array([my_settings_base, my_settings_other]) # unchanged
        expect(seeded_user_role.miq_product_features).to match_array([my_settings_other]) # unchanged

        expect(product_feature_stub.where(:identifier => "my_settings_view")).to match_array([my_settings_view])
      end
    end
  end
end
