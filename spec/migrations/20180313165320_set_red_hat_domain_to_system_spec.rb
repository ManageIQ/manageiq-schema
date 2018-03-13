require_migration

describe SetRedHatDomainToSystem do
  let(:miq_ae_namespace_stub) { migration_stub(:MiqAeNamespace) }

  migration_context :up do
    it "sets system to source for RedHat domain" do
      miq_ae_namespace_stub.create!(:name => 'RedHat', :parent_id => nil)

      migrate

      expect(miq_ae_namespace_stub.find_by(:name => 'RedHat').source).to eq("system")
    end
  end
end
