require_migration

# rubocop:disable Style/HashSyntax
describe MoveMiqSetMemberships do
  let(:rel_stub)        { migration_stub(:Relationship) }
  let(:membership_stub) { migration_stub(:MiqSetMembership) }
  let(:set_stub)        { Class.new(ActiveRecord::Base) { self.table_name = "miq_sets" } }
  let(:item_stub)       { Class.new(ActiveRecord::Base) { self.table_name = "scan_items" } }
  let(:rp_stub)         { Class.new(ActiveRecord::Base) { self.table_name = "resource_pools" } }

  migration_context :up do
    it 'converts relationship records to set membership table records' do
      # Empty Set
      set1 = set_stub.create!
      create_rel(set1, resource_type: "ScanItemSet")

      # Single Child
      set2  = set_stub.create!
      item1 = item_stub.create!

      set2_rel = create_rel(set2, resource_type: "ScanItemSet")
      create_rel(item1, ancestry: set2_rel.id.to_s)

      # Multi Child (with shared child)
      set3  = set_stub.create!
      item2 = item_stub.create!
      item3 = item_stub.create!
      item4 = item_stub.create!

      set3_rel = create_rel(set3, resource_type: "ScanItemSet")
      create_rel(item1, ancestry: set3_rel.id.to_s)
      create_rel(item2, ancestry: set3_rel.id.to_s)
      create_rel(item3, ancestry: set3_rel.id.to_s)
      create_rel(item4, ancestry: set3_rel.id.to_s)

      # Extra non-MiqSet relations
      create_resource_pool

      migrate

      membership1 = membership_stub.find_by(:member_id => item1.id, :miq_set_id => set2.id)
      membership2 = membership_stub.find_by(:member_id => item1.id, :miq_set_id => set3.id)
      membership3 = membership_stub.find_by(:member_id => item2.id, :miq_set_id => set3.id)
      membership4 = membership_stub.find_by(:member_id => item3.id, :miq_set_id => set3.id)
      membership5 = membership_stub.find_by(:member_id => item4.id, :miq_set_id => set3.id)

      expect(membership1).to have_attributes(:miq_set_id => set2.id, :member_type => "ScanItem")
      expect(membership2).to have_attributes(:miq_set_id => set3.id, :member_type => "ScanItem")
      expect(membership3).to have_attributes(:miq_set_id => set3.id, :member_type => "ScanItem")
      expect(membership4).to have_attributes(:miq_set_id => set3.id, :member_type => "ScanItem")
      expect(membership5).to have_attributes(:miq_set_id => set3.id, :member_type => "ScanItem")

      # Total MiqSetMembership records after migration
      expect(membership_stub.count).to eq(5)
      # Remaining Membership relationships after migration
      expect(rel_stub.where(:relationship => 'membership').count).to eq(0)
      # Remaining ResourcePool relationships after migration
      expect(rel_stub.count).to eq(2)
    end
  end

  migration_context :down do
    it 'converts set membership table records to relationship records' do
      # Empty Set
      set1 = set_stub.create!

      # Single Child
      set2  = set_stub.create!
      item1 = item_stub.create!

      membership_stub.create!(:miq_set_id => set2.id, :member_type => "ScanItem", :member_id => item1.id)

      # Multi Child (with shared child)
      set3  = set_stub.create!
      item2 = item_stub.create!
      item3 = item_stub.create!
      item4 = item_stub.create!

      membership_stub.create!(:miq_set_id => set3.id, :member_type => "ScanItem", :member_id => item1.id)
      membership_stub.create!(:miq_set_id => set3.id, :member_type => "ScanItem", :member_id => item2.id)
      membership_stub.create!(:miq_set_id => set3.id, :member_type => "ScanItem", :member_id => item3.id)
      membership_stub.create!(:miq_set_id => set3.id, :member_type => "ScanItem", :member_id => item4.id)

      # Extra non-MiqSet relations
      create_resource_pool

      migrate

      # Ensure we now are back to 7 records.  3 parents and 5 children (one shared between 2 parents).
      parent_rel1 = rel_stub.find_by(:resource_type => "ScanItemSet", :resource_id => set1.id, :ancestry => nil)
      parent_rel2 = rel_stub.find_by(:resource_type => "ScanItemSet", :resource_id => set2.id, :ancestry => nil)
      parent_rel3 = rel_stub.find_by(:resource_type => "ScanItemSet", :resource_id => set3.id, :ancestry => nil)
      child_rel1  = rel_stub.find_by(:resource_type => "ScanItem", :resource_id => item1.id, :ancestry => parent_rel2.id.to_s)
      child_rel2  = rel_stub.find_by(:resource_type => "ScanItem", :resource_id => item1.id, :ancestry => parent_rel3.id.to_s)
      child_rel3  = rel_stub.find_by(:resource_type => "ScanItem", :resource_id => item2.id, :ancestry => parent_rel3.id.to_s)
      child_rel4  = rel_stub.find_by(:resource_type => "ScanItem", :resource_id => item3.id, :ancestry => parent_rel3.id.to_s)
      child_rel5  = rel_stub.find_by(:resource_type => "ScanItem", :resource_id => item4.id, :ancestry => parent_rel3.id.to_s)

      # Won't get created since there was no members.  However, in the code,
      # when `.add_member` is called, it will create one if it doesn't exist.
      #
      #   https://github.com/ManageIQ/manageiq/blob/470e8b42/lib/extensions/ar_miq_set.rb#L95-L98
      #   https://github.com/ManageIQ/manageiq/blob/470e8b42/app/models/mixins/relationship_mixin.rb#L612
      #
      # expect(parent_rel1).to have_attributes(:relationship => "membership", :resource_type => "ScanItemSet", :ancestry => nil)

      expect(parent_rel2).to have_attributes(:relationship => "membership", :resource_type => "ScanItemSet", :ancestry => nil)
      expect(parent_rel3).to have_attributes(:relationship => "membership", :resource_type => "ScanItemSet", :ancestry => nil)
      expect(child_rel1).to  have_attributes(:relationship => "membership", :resource_type => "ScanItem", :ancestry => parent_rel2.id.to_s)
      expect(child_rel2).to  have_attributes(:relationship => "membership", :resource_type => "ScanItem", :ancestry => parent_rel3.id.to_s)
      expect(child_rel3).to  have_attributes(:relationship => "membership", :resource_type => "ScanItem", :ancestry => parent_rel3.id.to_s)
      expect(child_rel4).to  have_attributes(:relationship => "membership", :resource_type => "ScanItem", :ancestry => parent_rel3.id.to_s)
      expect(child_rel5).to  have_attributes(:relationship => "membership", :resource_type => "ScanItem", :ancestry => parent_rel3.id.to_s)

      expect(membership_stub.count).to eq(0)
      expect(rel_stub.where(:relationship => 'ems_metadata').count).to eq(2)
    end
  end

  def create_rel(resource, ancestry: nil, relationship: "membership", resource_type: "ScanItem")
    rel_stub.create!(:relationship => relationship, :ancestry => ancestry, :resource_id => resource.id, :resource_type => resource_type)
  end

  def create_resource_pool
    rp_stub.find_or_create_by!(:name => "large pool").tap do |resource_pool|
      parent = create_rel(resource_pool, relationship: 'ems_metadata', resource_type: "ResourcePool")

      sub_resource_pool = rp_stub.create!(:name => "kiddie pool")
      create_rel(sub_resource_pool, ancestry: parent.id.to_s, relationship: 'ems_metadata', resource_type: "ResourcePool")
    end
  end
end
# rubocop:enable Style/HashSyntax
