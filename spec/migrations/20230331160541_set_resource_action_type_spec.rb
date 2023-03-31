require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe SetResourceActionType do
  let(:resource_action_stub) { migration_stub(:ResourceAction) }

  migration_context :up do
    it "sets the ResourceAction type column" do
      resource_action = resource_action_stub.create!
      migrate
      expect(resource_action.reload.type).to eq("ResourceActionAutomate")
    end
  end

  migration_context :down do
    it "Clears the ResourceAction type column" do
      resource_action = resource_action_stub.create!
      migrate
      expect(resource_action.reload.type).to be_nil
    end
  end
end
