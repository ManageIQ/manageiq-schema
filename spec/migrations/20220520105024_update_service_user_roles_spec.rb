require_migration

describe UpdateServiceUserRoles do
  migration_context :up do
    let(:user_role_stub) { migration_stub(:MiqUserRole) }
    let(:product_feature_stub) { migration_stub(:MiqProductFeature) }

    let!(:other) { product_feature_stub.create!(:feature_type => "node", :identifier => "other") }
    let!(:service) { product_feature_stub.create!(:feature_type => "node", :identifier => "service") }
    let!(:service_accord) { product_feature_stub.create!(:feature_type => "node", :identifier => "service_accord") }

    it "does nothing to roles without service_accord" do
      user_role = user_role_stub.create!(:miq_product_features => [other], :read_only => false)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).to match_array([other.id])
    end

    it "converts service_accord to service" do
      user_role = user_role_stub.create!(:miq_product_features => [service_accord], :read_only => false)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).to match_array([service.id])
    end

    it "converts service_accord to service without duplicate" do
      user_role = user_role_stub.create!(:miq_product_features => [other, service, service_accord], :read_only => false)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).to match_array([other.id, service.id])
    end

    it "leaves service alone" do
      user_role = user_role_stub.create!(:miq_product_features => [other, service], :read_only => false)

      migrate
      user_role.reload

      expect(user_role.miq_product_feature_ids).to match_array([other.id, service.id])
    end
  end
end
