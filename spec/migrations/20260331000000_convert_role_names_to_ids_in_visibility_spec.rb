require_migration

describe ConvertRoleNamesToIdsInVisibility do
  let(:custom_button_stub)   { migration_stub(:CustomButton) }
  let(:miq_widget_stub)      { migration_stub(:MiqWidget) }
  let(:miq_user_role_stub)   { migration_stub(:MiqUserRole) }

  let(:all_roles)            { ["_ALL_"] }
  let(:role_name_1)          { "EvmRole-operator" }
  let(:role_name_2)          { "EvmRole-administrator" }
  let(:invalid_role_name_1)  { "NonExistentRole" }
  let(:invalid_role_name_2)  { "AnotherMissingRole" }

  migration_context :up do
    it "converts role names to IDs for CustomButton and MiqWidget" do
      role1 = miq_user_role_stub.create!(:name => role_name_1)
      role2 = miq_user_role_stub.create!(:name => role_name_2)

      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [role_name_1, role_name_2]}
      )

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:roles => [role_name_1, role_name_2]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to match_array([role1.id, role2.id])
      expect(widget.reload.visibility[:roles]).to match_array([role1.id, role2.id])
    end

    it "returns empty array when role names don't exist" do
      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [invalid_role_name_1, invalid_role_name_2]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to eq([])
    end

    it "keeps valid roles when some are missing" do
      role1 = miq_user_role_stub.create!(:name => role_name_1)

      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [role_name_1, invalid_role_name_1]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to eq([role1.id])
    end

    it "preserves _ALL_ visibility" do
      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => all_roles}
      )

      migrate

      expect(button.reload.visibility[:roles]).to eq(all_roles)
    end

    it "skips records with no visibility" do
      button = custom_button_stub.create!(:name => "Test Button")

      migrate

      expect(button.reload.visibility).to eq({})
    end

    it "handles mixed role IDs and names" do
      role1 = miq_user_role_stub.create!(:name => role_name_1)
      role2 = miq_user_role_stub.create!(:name => role_name_2)

      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [role1.id, role_name_2]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to match_array([role1.id, role2.id])
    end
  end

  migration_context :down do
    it "converts role IDs back to names for CustomButton and MiqWidget" do
      role1 = miq_user_role_stub.create!(:name => role_name_1)
      role2 = miq_user_role_stub.create!(:name => role_name_2)

      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [role1.id, role2.id]}
      )

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:roles => [role1.id, role2.id]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to match_array([role_name_1, role_name_2])
      expect(widget.reload.visibility[:roles]).to match_array([role_name_1, role_name_2])
    end

    it "returns empty array when role IDs don't exist" do
      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => [999, 998]}
      )

      migrate

      expect(button.reload.visibility[:roles]).to eq([])
    end

    it "preserves _ALL_ visibility" do
      button = custom_button_stub.create!(
        :name       => "Test Button",
        :visibility => {:roles => all_roles}
      )

      migrate

      expect(button.reload.visibility[:roles]).to eq(all_roles)
    end
  end
end
