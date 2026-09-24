require_migration

describe SetDefaultOnExistingServerRoleRecords do
  let(:server_roles_stub) { migration_stub(:ServerRole) }

  migration_context :up do
    it "sets default on existing server roles" do
      automate_role  = server_roles_stub.create!(:name => "automate")
      git_owner_role = server_roles_stub.create!(:name => "git_owner")

      migrate

      expect(automate_role.reload).to be_default
      expect(git_owner_role.reload).not_to be_default
    end
  end
end
