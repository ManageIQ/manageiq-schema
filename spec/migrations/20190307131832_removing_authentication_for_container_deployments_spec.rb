require_migration

describe RemovingAuthenticationForContainerDeployments do
  let(:auth_stub) { migration_stub :Authentication }

  migration_context :up do
    before do
      auth_stub.create!(:type => 'AuthenticationAllowAll', :name => 'bad')
      auth_stub.create!(:type => 'AuthenticationGithub', :name => 'bad1')
      auth_stub.create!(:type => 'AuthenticationGoogle', :name => 'bad2')
      auth_stub.create!(:type => 'AuthenticationHtpasswd', :name => 'bad3')
      auth_stub.create!(:type => 'AuthenticationLdap', :name => 'bad4')
      auth_stub.create!(:type => 'AuthenticationOpenId', :name => 'bad5')
      auth_stub.create!(:type => 'AuthenticationRequestHeader', :name => 'bad6')
      auth_stub.create!(:type => 'AuthenticationRhsm', :name => 'bad7')
      auth_stub.create!(:type => 'AuthToken', :name => 'good')
      migrate
    end

    it "deletes authentication records" do
      expect(auth_stub.pluck(:name)).not_to include('bad', 'bad1', 'bad2', 'bad3', 'bad4', 'bad5', 'bad6', 'bad7')
    end

    it "doesn't delete unrelated records" do
      expect(auth_stub.pluck(:name).sort).to eq(%w[good])
    end
  end
end
