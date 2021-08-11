require_migration

describe DeleteRhnAuthentications do
  let(:authentication_stub) { migration_stub(:Authentication) }

  migration_context :up do
    it "deletes" do
      authentication_stub.create!(:authtype => "registration")
      authentication_stub.create!(:authtype => "registration_http_proxy")

      migrate

      expect(authentication_stub.count).to eq(0)
    end

    it "leaves" do
      authentication_stub.create!(:authtype => "default")
      authentication_stub.create!(:authtype => nil)

      migrate

      expect(authentication_stub.count).to eq(2)
    end
  end
end
