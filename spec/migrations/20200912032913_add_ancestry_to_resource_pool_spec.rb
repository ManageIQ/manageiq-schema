require_migration

describe AddAncestryToResourcePool do
  let(:rel_stub) { migration_stub(:Relationship) }
  let(:resource_pool_stub) { migration_stub :ResourcePool }
  let(:resource_pool) { resource_pool_stub.create! }
  let(:default_rel_type) { 'genealogy' }

  migration_context :up do
    context "parent/child/grandchild rel" do
      it 'updates ancestry' do
        tree = create_tree(:parent => {:child => :grandchild})
        parent, child, grandchild = tree[:parent], tree[:child], tree[:grandchild]

        migrate

        expect(child.reload.ancestry).to eq(ancestry_for(parent))
        expect(grandchild.reload.ancestry).to eq(ancestry_for(child, parent))
        expect(parent.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(0)
      end
    end

    context "complicated tree" do
      it 'updates ancestry' do
        tree = create_tree(:a => [{:c => :g}, {:b => {:d => [:e, :f]}}])
        a, b, c, d, e, f, g = tree[:a], tree[:b], tree[:c], tree[:d], tree[:e], tree[:f], tree[:g]

        migrate

        expect(a.reload.ancestry).to eq(nil)
        expect(b.reload.ancestry).to eq(ancestry_for(a))
        expect(c.reload.ancestry).to eq(ancestry_for(a))
        expect(g.reload.ancestry).to eq(ancestry_for(c, a))
        expect(e.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(f.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(rel_stub.count).to eq(0)
      end

      it 'does not change ems_metadata tree' do
        tree = create_tree(:a => [{:c => :g}, {:b => {:d => [:e, :f]}}])
        a, b, c, d, e, f, g = tree[:a], tree[:b], tree[:c], tree[:d], tree[:e], tree[:f], tree[:g]
        create_non_genealogy_rel(ancestry_for(a), c)
        create_non_genealogy_rel(ancestry_for(a, c), g)
        create_non_genealogy_rel(ancestry_for(a), b)
        create_non_genealogy_rel(ancestry_for(b, a), d)
        create_non_genealogy_rel(ancestry_for(d, b, a), e)
        create_non_genealogy_rel(ancestry_for(d, b, a), f)
        create_non_genealogy_rel(nil, a)

        migrate

        expect(a.reload.ancestry).to eq(nil)
        expect(b.reload.ancestry).to eq(ancestry_for(a))
        expect(c.reload.ancestry).to eq(ancestry_for(a))
        expect(g.reload.ancestry).to eq(ancestry_for(c, a))
        expect(e.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(f.reload.ancestry).to eq(ancestry_for(d, b, a))
        expect(rel_stub.count).to eq(7)
        expect(rel_stub.all.pluck(:relationship).uniq).to eq(['ems_metadata'])
      end
    end

    context "trivial cases" do
      it 'resource pool without rel record has nil ancestry' do
        migrate

        expect(resource_pool_stub.find(resource_pool.id).ancestry).to eq(nil)
      end

      it 'resource pool without ancestry' do
        create_tree(:a => nil)

        migrate

        expect(resource_pool_stub.find(resource_pool.id).ancestry).to eq(nil)
      end
    end

    context "with only ems_metadata relationship tree" do
      let(:default_rel_type) { 'ems_metadata' }
      it 'does not set resource_pool ancestry' do
        tree = create_tree(:parent => :child)
        parent, child = tree[:parent], tree[:child]

        migrate

        expect(resource_pool.reload.ancestry).to eq(nil)
        expect(child.reload.ancestry).to eq(nil)
        expect(parent.reload.ancestry).to eq(nil)
        expect(rel_stub.count).to eq(2)
      end
    end
  end

  migration_context :down do
    context "complicated tree" do
      #           a
      #      b         c
      #      d         g
      #    e   f
      it 'updates ancestry' do
        tree = create_tree(:a => [{:c => :g}, {:b => {:d => [:e, :f]}}])
        a, b, c, d, e, f, g = tree[:a], tree[:b], tree[:c], tree[:d], tree[:e], tree[:f], tree[:g]

        migrate

        expect(find_rel(a).ancestry).to eq(nil)
        expect(find_rel(b).ancestry).to eq(ancestry_for(find_rel(a)))
        expect(find_rel(c).ancestry).to eq(ancestry_for(find_rel(a)))
        expect(find_rel(g).ancestry).to eq(ancestry_for(find_rel(c), find_rel(a)))
        expect(find_rel(e).ancestry).to eq(ancestry_for(find_rel(d), find_rel(b), find_rel(a)))
        expect(find_rel(f).ancestry).to eq(ancestry_for(find_rel(d), find_rel(b), find_rel(a)))
      end

      it 'does not change ems_metadata tree' do
        tree = create_tree(:a => [{:c => :g}, {:b => {:d => [:e, :f]}}])
        a, b, c, d, e, f, g = tree[:a], tree[:b], tree[:c], tree[:d], tree[:e], tree[:f], tree[:g]
        create_non_genealogy_rel(ancestry_for(a), c)
        create_non_genealogy_rel(ancestry_for(a, c), g)
        create_non_genealogy_rel(ancestry_for(a), b)
        create_non_genealogy_rel(ancestry_for(b, a), d)
        create_non_genealogy_rel(ancestry_for(d, b, a), e)
        create_non_genealogy_rel(ancestry_for(d, b, a), f)
        create_non_genealogy_rel(nil, a)

        migrate

        expect(find_rel(a).ancestry).to eq(nil)
        expect(find_rel(b).ancestry).to eq(ancestry_for(find_rel(a)))
        expect(find_rel(c).ancestry).to eq(ancestry_for(find_rel(a)))
        expect(find_rel(g).ancestry).to eq(ancestry_for(find_rel(c), find_rel(a)))
        expect(find_rel(e).ancestry).to eq(ancestry_for(find_rel(d), find_rel(b), find_rel(a)))
        expect(find_rel(f).ancestry).to eq(ancestry_for(find_rel(d), find_rel(b), find_rel(a)))
        expect(rel_stub.count).to eq(14)
        expect(rel_stub.all.pluck(:relationship).uniq).to contain_exactly("genealogy", "ems_metadata")
      end
    end
  end

  private

  def find_rel(obj)
    rel_stub.all.detect { |r| r.resource_id == obj.id }
  end

  def create_tree(tree, relationship = default_rel_type)
    resources = {}
    traverse(tree, []) { |_, id| resources.merge!(id => resource_pool_stub.create!) }

    traverse(tree, []) do |parents, id|
      ancestry = parents.reverse.map { |s| rel_stub.find_by(:resource_id => resources[s].id).id }.compact.join('/') if parents.present?
      rel_stub.create!(:ancestry => ancestry, :resource_id => resources[id].id, :resource_type => 'ResourcePool', :relationship => relationship)
    end

    resources
  end

  def traverse(tree, parent, &block)
    case tree
    when Symbol || String
      yield(parent, tree)
    when Array
      tree.each { |node| traverse(node, parent, &block) }
    when Hash
      tree.each do |key, children|
        yield(parent, key)
        traverse(children, parent + [key], &block)
      end
    when nil
    else
      raise StandardError, "curious type: #{tree.class.name}"
    end
  end

  def create_non_genealogy_rel(ancestors, resource, relationship = 'ems_metadata')
    rel_stub.create!(:relationship => relationship, :ancestry => ancestors, :resource_type => 'ResourcePool', :resource_id => resource.id)
  end

  def ancestry_for(*nodes)
    nodes.map(&:id).join("/").presence
  end
end
