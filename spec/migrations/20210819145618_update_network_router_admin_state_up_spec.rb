require_migration

# conversions and reloading the schema were causing problems
# that is why there are so many entries here
describe UpdateNetworkRouterAdminStateUp do
  let(:network_router_stub) { migration_stub(:NetworkRouter) }

  migration_context :up do
    context "conversion" do
      it "converts to boolean" do
        record = network_router_stub.create!(:admin_state_up => false)
        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to be_kind_of(FalseClass)
      end

      it "converts null to false" do
        record = network_router_stub.create!
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(nil)

        migrate
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)
      end

      it "converts false to false" do
        record = network_router_stub.create!(:admin_state_up => false)
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq('f')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)
      end

      it "converts 'false' to false" do
        record = network_router_stub.create!(:admin_state_up => 'false')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)
      end

      it "converts 'f' to false" do
        record = network_router_stub.create!(:admin_state_up => 'f')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)
      end

      it "converts 'true' to true" do
        record = network_router_stub.create!(:admin_state_up => 'true')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(true)
      end

      it "converts true to true" do
        record = network_router_stub.create!(:admin_state_up => true)
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq('t')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(true)
      end

      it "converts 't' to true" do
        record = network_router_stub.create!(:admin_state_up => 't')
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq('t')

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(true)
      end
    end

    it "defaults to false" do
      migrate
      record = network_router_stub.create!
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(false)
    end

    it "doesn't support nil" do
      migrate
      expect do
        record = network_router_stub.create!(:admin_state_up => nil)
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "supports false" do
      migrate
      record = network_router_stub.create!(:admin_state_up => false)
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(false)
    end

    it "supports 'f'" do
      migrate
      record = network_router_stub.create!(:admin_state_up => 'f')
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(false)
    end

    it "supports true" do
      migrate
      record = network_router_stub.create!(:admin_state_up => true)
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(true)
    end

    it "supports 't'" do
      migrate
      record = network_router_stub.create!(:admin_state_up => 't')
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(true)
    end
  end

  migration_context :down do
    context "conversion" do
      it "converts to string" do
        record = network_router_stub.create!(:admin_state_up => false)
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to be_kind_of(String)
      end

      # exact string does not matter here
      it "converts false to 'false'" do
        record = network_router_stub.create!(:admin_state_up => false)
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(false)

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq('false')
        expect(admin_state_up).to be_kind_of(String)
      end

      it "converts 'true' to true" do
        record = network_router_stub.create!(:admin_state_up => true)
        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq(true)

        migrate

        admin_state_up = record.reload.admin_state_up
        expect(admin_state_up).to eq('true')
      end
    end

    it "defaults to nulls" do
      migrate
      record = network_router_stub.create!
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq(nil)
    end

    it "supports false" do
      migrate
      record = network_router_stub.create!(:admin_state_up => false)
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq('f')
    end

    it "supports true" do
      migrate
      record = network_router_stub.create!(:admin_state_up => true)
      admin_state_up = record.reload.admin_state_up
      expect(admin_state_up).to eq('t')
    end
  end
end
