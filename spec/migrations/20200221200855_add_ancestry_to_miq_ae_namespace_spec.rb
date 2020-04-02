require_migration

describe AddAncestryToMiqAeNamespace do
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
      ns1   = ns_stub.create!
      ns2   = ns_stub.create!
      ns11  = ns_stub.create!(:parent_id => ns1.id)
      ns111 = ns_stub.create!(:parent_id => ns11.id)
      ns112 = ns_stub.create!(:parent_id => ns11.id)
      ns21  = ns_stub.create!(:parent_id => ns2.id)

      migrate

      expect(ns1.reload.ancestry).to be_nil
      expect(ns2.reload.ancestry).to be_nil

      expect(ns11.reload.ancestry).to eq(ns1.id.to_s)
      expect(ns111.reload.ancestry).to eq("#{ns1.id}/#{ns11.id}")
      expect(ns112.reload.ancestry).to eq("#{ns1.id}/#{ns11.id}")
      expect(ns21.reload.ancestry).to eq(ns2.id.to_s)
    end
  end

  migration_context :down do
    it "updates tree" do
      ns1   = ns_stub.create!
      ns2   = ns_stub.create!
      ns11  = ns_stub.create!(:ancestry => ns1.id)
      ns111 = ns_stub.create!(:ancestry => "#{ns1.id}/#{ns11.id}")
      ns112 = ns_stub.create!(:ancestry => "#{ns1.id}/#{ns11.id}")
      ns21  = ns_stub.create!(:ancestry => ns2.id)

      migrate

      expect(ns1.reload.parent_id).to eq(nil)
      expect(ns2.reload.parent_id).to eq(nil)

      expect(ns11.reload.parent_id).to eq(ns1.id)
      expect(ns111.reload.parent_id).to eq(ns11.id)
      expect(ns112.reload.parent_id).to eq(ns11.id)
      expect(ns21.reload.parent_id).to eq(ns2.id)
    end
  end
end
