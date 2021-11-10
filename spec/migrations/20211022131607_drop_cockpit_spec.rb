require_migration

describe DropCockpit do
  let(:server_role_stub)          { migration_stub(:ServerRole) }
  let(:assigned_server_role_stub) { migration_stub(:AssignedServerRole) }
  let(:miq_product_feature_stub)  { migration_stub(:MiqProductFeature) }
  let(:miq_user_role_stub)        { migration_stub(:MiqUserRole) }
  let(:miq_role_feature_stub)     { migration_stub(:MiqRolesFeature) }

  migration_context :up do
    it "deletes only cockpit active services" do
      cockpit = server_role_stub.find_or_create_by!(:name => "cockpit_ws")
      other   = server_role_stub.create!(:name => "other_service")

      assigned_server_role_stub.create!(:server_role_id => other.id)
      3.times do
        assigned_server_role_stub.create!(:server_role_id => cockpit.id)
      end

      expect(assigned_server_role_stub.where(:server_role_id => cockpit.id).count).to eq(3)
      expect(assigned_server_role_stub.where(:server_role_id => other.id).count).to eq(1)

      migrate

      expect(assigned_server_role_stub.where(:server_role_id => other.id).count).to eq(1)
      expect(assigned_server_role_stub.where(:server_role_id => cockpit.id).count).to eq(0)

      expect(server_role_stub.where(:name => "other_service").count).to eq(1)
      expect(server_role_stub.where(:name => "cockpit_ws").count).to eq(0)
    end

    it "deletes product features" do
      product_feature = miq_product_feature_stub.find_or_create_by!(:identifier => "cockpit_console")
      other_feature   = miq_product_feature_stub.create!(:identifier => "other_console")
      role = miq_user_role_stub.create(:name => "role1")

      miq_role_feature_stub.create(:miq_user_role_id => role.id, :miq_product_feature_id => product_feature.id)
      other_role_feature = miq_role_feature_stub.create(:miq_user_role_id => role.id, :miq_product_feature_id => other_feature.id)

      migrate

      expect(miq_role_feature_stub.all).to eq([other_role_feature])
      expect(miq_product_feature_stub.where(:identifier => "other_console").count).to eq(1)
      expect(miq_product_feature_stub.where(:identifier => "cockpit_console").count).to eq(0)
    end
  end
end
