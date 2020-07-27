class AddAncestryToEmsFolder < ActiveRecord::Migration[5.2]
  include RelationshipAncestryConverterHelper
  class EmsFolder < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :all_relationships, :class_name => "AddAncestryToEmsFolder::Relationship", :dependent => :destroy, :as => :resource
    include ActiveRecord::IdRegions
  end

  class ResourcePool < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :all_relationships, :class_name => "AddAncestryToEmsFolder::Relationship", :dependent => :destroy, :as => :resource
    include ActiveRecord::IdRegions
  end

  class Relationship < ActiveRecord::Base
    belongs_to :ems_folder, :class_name => 'AddAncestryToEmsFolder::EmsFolder'
    belongs_to :resource_pool, :class_name => 'AddAncestryToEmsFolder::ResourcePool'
  end

  def up
    add_column :ems_folders, :ancestry, :string
    add_column :resource_pools, :ancestry, :string
    add_index :ems_folders, :ancestry
    add_index :resource_pools, :ancestry

    say_with_time("set ems folder ancestry from existing ems_metadata relationship information") do
      ancestry_resources = ancestry_resource_ids('ems_metadata', "EmsFolder", EmsFolder.rails_sequence_range(EmsFolder.my_region_number))
      ancestry_sources = ancestry_src_ids(ancestry_resources)
      new_ancestors = ancestry_of_src_ids_for_src(ancestry_sources)
      connection.execute(update_src(new_ancestors, EmsFolder))
    end

    say_with_time("set resource pool ancestry from existing ems_metadata relationship information") do
      ancestry_resources = ancestry_resource_ids('ems_metadata', "ResourcePool", ResourcePool.rails_sequence_range(ResourcePool.my_region_number))
      ancestry_sources = ancestry_src_ids(ancestry_resources)
      new_ancestors = ancestry_of_src_ids_for_src(ancestry_sources)
      connection.execute(update_src(new_ancestors, ResourcePool))
    end

    Relationship.where(:relationship => 'ems_metadata', :resource_type => 'EmsFolder', :resource_id => EmsFolder.all.select(:id)).delete_all
    Relationship.where(:relationship => 'ems_metadata', :resource_type => 'ResourcePool', :resource_id => ResourcePool.all.select(:id)).delete_all
  end

  def down
    say_with_time("create relationship records from resource pool ancestry") do
      rps_with_ancestry = ResourcePool.where.not(:ancestry => nil)
      rps_with_ancestry.each do |rp|
        Relationship.create!(:relationship => 'ems_metadata', :resource_type => 'ResourcePool', :resource_id => rp.id, :ancestry => rp.ancestry)
      end

      remove_column :resource_pools, :ancestry
    end

    say_with_time("create relationship records from ems folder ancestry") do
      folders_with_ancestry = EmsFolder.where.not(:ancestry => nil)
      folders_with_ancestry.each do |folder|
        Relationship.create!(:relationship => 'ems_metadata', :resource_type => 'EmsFolder', :resource_id => folder.id, :ancestry => folder.ancestry)
      end

      remove_column :ems_folders, :ancestry
    end
  end
end
