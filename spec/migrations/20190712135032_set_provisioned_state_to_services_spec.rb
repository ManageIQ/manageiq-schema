require_migration

describe SetProvisionedStateToServices do
  let(:service) { migration_stub(:Service) }

  migration_context :up do
    it "sets lifecycle state" do
      obj1 = service.create!(:lifecycle_state => nil)

      expect(obj1.reload.lifecycle_state).to eq(nil)

      migrate

      expect(obj1.reload.lifecycle_state).to eq('provisioned')
    end
  end
end
