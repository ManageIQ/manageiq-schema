require_migration

describe AppendAlertStatusesFeature do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    it "appends the 'alert_status' feature to all roles with an 'alert' role" do
      alert = feature_stub.create!(:identifier => 'alert')

      roles_feature_stub.create!(:miq_product_feature_id => alert.id, :miq_user_role_id => user_role_id)

      migrate

      alert_status = feature_stub.find_by!(:identifier => 'alert_status')
      assigned = roles_feature_stub.where(:miq_product_feature_id => alert_status.id, :miq_user_role_id => user_role_id)

      expect(assigned.count).to eq(1)
    end
  end
end
