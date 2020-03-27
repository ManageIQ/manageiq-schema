require_migration

describe AddDomainAndPartialNamespaceToMiqAeNamespace do
  let(:ns_stub) { Class.new(ActiveRecord::Base) { self.table_name = "miq_ae_namespaces" } }

  migration_context :up do
    # nodes:
    # ns1
    #   ns11
    #     ns111
    #     ns112
    # ns2
    #   ns21
    it "updates tree" do
      ns1   = ns_stub.create!(:name => 'ns1')
      ns2   = ns_stub.create!(:name => 'ns2')
      ns11  = ns_stub.create!(:name => 'ns11', :ancestry => ns1.id.to_s)
      ns111 = ns_stub.create!(:name => 'ns111', :ancestry => "#{ns1.id}/#{ns11.id}")
      ns112 = ns_stub.create!(:name => 'ns112', :ancestry => "#{ns1.id}/#{ns11.id}")
      ns21  = ns_stub.create!(:name => 'ns21', :ancestry => ns2.id.to_s)

      migrate

      expect(ns1.reload.domain_name).to eq(ns1.name)
      expect(ns2.reload.domain_name).to eq(ns2.name)
      expect(ns1.partial_namespace).to be_nil
      expect(ns2.partial_namespace).to be_nil

      expect(ns11.reload.domain_name).to eq(ns1.name)
      expect(ns111.reload.domain_name).to eq(ns1.name)
      expect(ns112.reload.domain_name).to eq(ns1.name)
      expect(ns21.reload.domain_name).to eq(ns2.name)
      expect(ns11.partial_namespace).to eq("#{ns11.name}")
      expect(ns111.partial_namespace).to eq("#{ns11.name}/#{ns111.name}")
      expect(ns112.partial_namespace).to eq("#{ns11.name}/#{ns112.name}")
      expect(ns21.partial_namespace).to eq("#{ns21.name}")
    end
  end
end
