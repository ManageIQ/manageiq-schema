require_migration

describe MoveMiqSetMemberships do
  let(:rel_stub) { migration_stub(:Relationship) }
  let(:membership_stub) { migration_stub(:MiqSetMembership) }
  let(:ns_stub) { Class.new(ActiveRecord::Base) { self.table_name = "miq_ae_namespaces" } }

  migration_context :up do
    context "two sets with one member each" do
      it 'converts relationship records to set membership table records' do
        ns1 = ns_stub.create!
        ns2 = ns_stub.create!
        ns1_child = ns_stub.create!
        ns2_child = ns_stub.create!
        ns1_rel = create_rel(ns1, nil)
        ns2_rel = create_rel(ns2, nil)
        create_rel(ns1_child, ancestry_for(ns1_rel))
        create_rel(ns2_child, ancestry_for(ns2_rel))

        migrate

        expect(membership_stub.find_by(:member_id => ns1_child.id)).to have_attributes(:miq_set_id => ns1.id, :member_type => "MiqAeNamespace")
        expect(membership_stub.find_by(:member_id => ns2_child.id)).to have_attributes(:miq_set_id => ns2.id, :member_type => "MiqAeNamespace")
      end
    end
  end

  migration_context :down do
    context "two sets with one member each" do
      it 'converts set membership table records to relationship records' do
        ns1 = ns_stub.create!
        ns2 = ns_stub.create!
        ns1_child = ns_stub.create!
        ns2_child = ns_stub.create!
        membership_stub.create!(:miq_set_id => ns1.id, :member_type => "MiqAeNamespace", :member_id => ns1_child.id)
        membership_stub.create!(:miq_set_id => ns2.id, :member_type => "MiqAeNamespace", :member_id => ns2_child.id)

        migrate

        expect(rel_stub.find_by(:resource_id => ns1_child.id)).to have_attributes(:relationship => "membership", :resource_type => "MiqAeNamespace", :ancestry => ns1.id.to_s)
        expect(rel_stub.find_by(:resource_id => ns2_child.id)).to have_attributes(:relationship => "membership", :resource_type => "MiqAeNamespace", :ancestry => ns2.id.to_s)
      end
    end
  end

  def ancestry_for(*nodes)
    nodes.map(&:id).join("/").presence
  end

  def create_rel(resource, ancestry, relationship = "membership", resource_type = "MiqAeNamespace")
    rel_stub.create!(:relationship => relationship, :ancestry => ancestry, :resource_id => resource.id, :resource_type => resource_type)
  end
end
