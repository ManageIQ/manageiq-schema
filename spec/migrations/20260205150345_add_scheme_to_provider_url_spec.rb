require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe AddSchemeToProviderUrl do
  let(:endpoint_stub) { migration_stub(:Endpoint) }
  let(:provider_stub) { migration_stub(:Provider) }

  migration_context :up do
    let(:awx_provider) { provider_stub.create!(:type => "ManageIQ::Providers::Awx::Provider") }
    let(:aap_provider) { provider_stub.create!(:type => "ManageIQ::Providers::AnsibleTower::Provider") }

    it "adds http to a url without a scheme" do
      awx_endpoint = endpoint_stub.create!(:url => "192.168.122.10:3000", :resource_type => "Provider", :resource_id => awx_provider.id)
      aap_endpoint = endpoint_stub.create!(:url => "192.168.122.20:3000", :resource_type => "Provider", :resource_id => aap_provider.id)

      migrate

      expect(awx_endpoint.reload.url).to eq("http://192.168.122.10:3000")
      expect(aap_endpoint.reload.url).to eq("http://192.168.122.20:3000")
    end

    it "doesn't add http to a url with a scheme" do
      awx_endpoint = endpoint_stub.create!(:url => "https://192.168.122.10:3000", :resource_type => "Provider", :resource_id => awx_provider.id)
      aap_endpoint = endpoint_stub.create!(:url => "ftp://192.168.122.20:3000", :resource_type => "Provider", :resource_id => aap_provider.id)

      migrate

      expect(awx_endpoint.reload.url).to eq("https://192.168.122.10:3000")
      expect(aap_endpoint.reload.url).to eq("ftp://192.168.122.20:3000")
    end

    it "doesn't update nil urls" do
      awx_endpoint = endpoint_stub.create!(:url => nil, :resource_type => "Provider", :resource_id => awx_provider.id)

      migrate

      expect(awx_endpoint.reload.url).to be_nil
    end

    it "doesn't update other providers" do
      foreman_provider = provider_stub.create!(:type => "ManageIQ::Providers::Foreman::Provider")
      foreman_endpoint = endpoint_stub.create!(:url => "192.168.122.10:3000", :resource_type => "Provider", :resource_id => foreman_provider.id)

      migrate

      expect(foreman_endpoint.reload.url).to eq("192.168.122.10:3000")
    end
  end
end
