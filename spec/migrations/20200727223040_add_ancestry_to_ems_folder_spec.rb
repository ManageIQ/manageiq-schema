require_migration

describe AddAncestryToEmsFolder do
  let(:rel_stub) { migration_stub(:Relationship) }
  let(:ems_folder_stub) { migration_stub :EmsFolder }
  let(:resource_pool_stub) { migration_stub :ResourcePool }
  let(:ems_folder) { ems_folder_stub.create! }
  let(:rp) { resource_pool_stub.create! }

  migration_context :up do
    context "complicated tree" do
      it 'updates ancestry' do
        #           a
        #      b         c
        #      d         g
        #    e   f
        a = ems_folder_stub.create!
        b = resource_pool_stub.create!
        c = ems_folder_stub.create!
        d = resource_pool_stub.create!
        e = resource_pool_stub.create!
        f = ems_folder_stub.create!
        g = resource_pool_stub.create!

        a_rel = create_rel(a, 'ems_metadata', 'EmsFolder')
        b_rel = create_rel(b, 'ems_metadata', 'ResourcePool', ancestry_for(a_rel))
        c_rel = create_rel(c, 'ems_metadata', 'EmsFolder', ancestry_for(a_rel))
        d_rel = create_rel(d, 'ems_metadata', 'ResourcePool', ancestry_for(b_rel, a_rel))
        create_rel(e, 'ems_metadata', 'ResourcePool', ancestry_for(d_rel, b_rel, a_rel))    # e_rel
        create_rel(f, 'ems_metadata', 'EmsFolder', ancestry_for(d_rel, b_rel, a_rel))       # f_rel
        create_rel(g, 'ems_metadata', 'ResourcePool', ancestry_for(c_rel, a_rel))           # g_rel

        migrate

        expect(a.reload.ancestry).to eq(nil)
        expect(b.reload.ancestry).to eq(ancestry_for(a))
        expect(c.reload.ancestry).to eq(ancestry_for(a))
        expect(g.reload.ancestry).to eq(ancestry_for(c, a))
        expect(e.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(f.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(rel_stub.count).to eq(0)
      end
    end

    context "vm without rels" do
      it 'nil ancestry' do
        migrate

        expect(resource_pool_stub.find(rp.id).ancestry).to eq(nil)
        expect(ems_folder_stub.find(ems_folder.id).ancestry).to eq(nil)
      end
    end
  end

  migration_context :down do
    context "multiple rels" do
      let!(:rp) { resource_pool_stub.create(:ancestry => '6/5/4') }
      it 'creates rel and removes ancestry' do
        migrate

        rel = rel_stub.first
        expect(rel.relationship).to eq('ems_metadata')
        expect(rel.ancestry).to eq('6/5/4')
        expect(rel.resource_type).to eq('ResourcePool')
        expect(rel.resource_id).to eq(rp.id)
      end
    end

    context "single rel" do
      let!(:folder) { ems_folder_stub.create(:ancestry => '645') }
      it 'creates rel and removes ancestry' do
        migrate

        rel = rel_stub.first
        expect(rel.relationship).to eq('ems_metadata')
        expect(rel.ancestry).to eq('645')
        expect(rel.resource_type).to eq('EmsFolder')
        expect(rel.resource_id).to eq(folder.id)
      end
    end
  end

  def ancestry_for(*nodes)
    nodes.map(&:id).join("/").presence
  end

  def create_rel(resource, relationship, resource_type, ancestors = nil)
    rel_stub.create!(:relationship => relationship, :ancestry => ancestors.nil? ? nil : ancestors, :resource_type => resource_type, :resource_id => resource.id)
  end
end
