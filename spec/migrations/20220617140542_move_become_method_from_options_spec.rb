require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe MoveBecomeMethodFromOptions do
  let(:authentication_stub) { migration_stub(:Authentication) }

  migration_context :up do
    it "without options[:become_method] set doesn't modify authentication records" do
      authentication = authentication_stub.create!

      updated_on = authentication.updated_on

      migrate

      expect(authentication.reload.updated_on).to be_within(0.01).of(updated_on)
    end

    it "moves options[:become_method] to column" do
      authentication = authentication_stub.create!(:options => {:become_method => "su"})

      migrate

      authentication.reload
      expect(authentication.become_method).to eq("su")
      expect(authentication.options.keys).not_to include(:become_method)
    end

    it "clears invalid values" do
      authentication = authentication_stub.create!(:options => {:become_method => "rm -rf"})

      migrate

      authentication.reload
      expect(authentication.become_method).to be_nil
      expect(authentication.options.keys).not_to include(:become_method)
    end
  end

  migration_context :down do
    it "without :become_method set doesn't modify authentication records" do
      authentication = authentication_stub.create!

      updated_on = authentication.updated_on

      migrate

      expect(authentication.reload.updated_on).to be_within(0.01).of(updated_on)
    end

    it "moves :become_method to :options" do
      authentication = authentication_stub.create!(:become_method => "su")

      migrate

      expect(authentication.reload.options).to include(:become_method => "su")
    end
  end
end
