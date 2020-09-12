require_migration

describe AddAncestryToResourcePool do
  let(:rel_stub) { migration_stub(:Relationship) }
  let(:resource_pool_stub) { migration_stub :ResourcePool }
  let(:resource_pool) { resource_pool_stub.create! }
  let(:resource_pool2) { resource_pool_stub.create! }
  let(:resource_pool3) { resource_pool_stub.create! }
  let(:resource_pool4) { resource_pool_stub.create! }
  let(:resource_pool5) { resource_pool_stub.create! }
  let(:resource_pool6) { resource_pool_stub.create! }
  let(:resource_pool7) { resource_pool_stub.create! }
  let(:resource_pool8) { resource_pool_stub.create! }
  let(:root) { resource_pool_stub.create! }

  migration_context :up do
    context "single parent/child rel" do
      it 'updates ancestry' do
        parent_rel = rel_stub.create!(:relationship => 'genealogy', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => parent_rel.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)

        migrate

        expect(resource_pool.reload.ancestry).to eq(root.id.to_s)
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(0)
      end
    end

    context "slightly more complicated tree" do
      it 'updates ancestry' do
        parent_rel = rel_stub.create!(:relationship => 'genealogy', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        child_rel = rel_stub.create!(:relationship => 'genealogy', :ancestry => parent_rel.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => child_rel.id.to_s + '/' + parent_rel.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool2.id)

        migrate

        expect(resource_pool.reload.ancestry).to eq(root.id.to_s)
        expect(resource_pool2.reload.ancestry).to eq("#{resource_pool.id}/#{root.id}")
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(0)
      end
    end

    context "complicated tree" do
      #           a
      #      b         c
      #      d         g
      #    e   f
      it 'updates ancestry' do
        rel_a = rel_stub.create!(:relationship => 'genealogy', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_c = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_a.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_c.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool2.id)
        rel_b = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool3.id)
        rel_d = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool4.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool5.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool6.id)

        migrate

        expect(resource_pool5.reload.ancestry).to eq("#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool6.reload.ancestry).to eq("#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool3.reload.ancestry).to eq(root.id.to_s)
        expect(resource_pool.reload.ancestry).to eq(root.id.to_s)
        expect(resource_pool2.reload.ancestry).to eq("#{resource_pool.id}/#{root.id}")
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(0)
      end
    end

    context "order is preserved" do
      #      rel resource_pool
      #      a   root
      #      b   3
      #      d   4
      #      e   6
      #      c   resource_pool
      #      f   2
      #      g   7
      #      h   8
      it 'updates ancestry' do
        rel_a = rel_stub.create!(:relationship => 'genealogy', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_b = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool3.id)
        rel_d = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool4.id)
        rel_e = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool6.id)
        rel_c = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_e.id.to_s + '/' + rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)
        rel_f = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_c.id.to_s + '/' + rel_e.id.to_s + '/' + rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool2.id)
        rel_g = rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_f.id.to_s + '/' + rel_c.id.to_s + '/' + rel_e.id.to_s + '/' + rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool7.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => rel_g.id.to_s + '/' + rel_f.id.to_s + '/' + rel_c.id.to_s + '/' + rel_e.id.to_s + '/' + rel_d.id.to_s + '/' + rel_b.id.to_s + '/' + rel_a.id.to_s, :resource_type => 'ResourcePool', :resource_id => resource_pool8.id)

        migrate

        expect(resource_pool2.reload.ancestry).to eq("#{resource_pool.id}/#{resource_pool6.id}/#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool6.reload.ancestry).to eq("#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool3.reload.ancestry).to eq(root.id.to_s)
        expect(resource_pool.reload.ancestry).to eq("#{resource_pool6.id}/#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool7.reload.ancestry).to eq("#{resource_pool2.id}/#{resource_pool.id}/#{resource_pool6.id}/#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(resource_pool8.reload.ancestry).to eq("#{resource_pool7.id}/#{resource_pool2.id}/#{resource_pool.id}/#{resource_pool6.id}/#{resource_pool4.id}/#{resource_pool3.id}/#{root.id}")
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(0)
      end
    end

    context "resource_pool without rels" do
      it 'nil ancestry' do
        migrate

        expect(resource_pool_stub.find(resource_pool.id).ancestry).to eq(nil)
      end
    end

    context "with only ems_metadata relationship tree" do
      it 'sets nothing' do
        parent_rel = rel_stub.create!(:relationship => 'ems_metadata', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_stub.create!(:relationship => 'ems_metadata', :ancestry => parent_rel.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)

        migrate

        expect(resource_pool.reload.ancestry).to eq(nil)
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(2)
      end
    end

    context "with rel type that isn't resource_pool_or_template" do
      it 'sets nothing' do
        parent_rel = rel_stub.create!(:relationship => 'ems_metadata', :ancestry => nil, :resource_type => 'Host', :resource_id => root.id)
        rel_stub.create!(:relationship => 'ems_metadata', :ancestry => parent_rel.id, :resource_type => 'Host', :resource_id => resource_pool.id)

        migrate

        expect(resource_pool.reload.ancestry).to eq(nil)
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(2)
      end
    end

    context "with both genealogy and ems_metadata rels" do
      it 'only sets ancestry from genealogy rels' do
        invalid_parent_rel = rel_stub.create!(:relationship => 'ems_metadata', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_stub.create!(:relationship => 'ems_metadata', :ancestry => invalid_parent_rel.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)
        parent_rel = rel_stub.create!(:relationship => 'genealogy', :ancestry => nil, :resource_type => 'ResourcePool', :resource_id => root.id)
        rel_stub.create!(:relationship => 'genealogy', :ancestry => parent_rel.id, :resource_type => 'ResourcePool', :resource_id => resource_pool.id)

        migrate

        expect(resource_pool.reload.ancestry).to eq(root.id.to_s)
        expect(root.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(2)
      end
    end
  end

  migration_context :down do
    context "multiple rels" do
      let!(:resource_pool) { resource_pool_stub.create!(:ancestry => '6/5/4') }
      it 'creates rel and removes ancestry' do
        migrate

        rel = rel_stub.first
        expect(rel.relationship).to eq('genealogy')
        expect(rel.ancestry).to eq('6/5/4')
        expect(rel.resource_type).to eq('ResourcePool')
        expect(rel.resource_id).to eq(resource_pool.id)
      end
    end

    context "single rel" do
      let!(:resource_pool) { resource_pool_stub.create!(:ancestry => '645') }
      it 'creates rel and removes ancestry' do
        migrate

        rel = rel_stub.first
        expect(rel.relationship).to eq('genealogy')
        expect(rel.ancestry).to eq('645')
        expect(rel.resource_type).to eq('ResourcePool')
        expect(rel.resource_id).to eq(resource_pool.id)
      end
    end
  end
end
