class AddAncestryToResourcePool < ActiveRecord::Migration[5.2]
  class ResourcePool < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :all_relationships, :class_name => "AddAncestryToResourcePool::Relationship", :dependent => :destroy, :as => :resource
    include ActiveRecord::IdRegions
  end

  class Relationship < ActiveRecord::Base
    belongs_to :resource_pool, :class_name => 'AddAncestryToResourcePool::ResourcePool', :foreign_key => :resource_pool_id
  end

  def up
    add_column :resource_pools, :ancestry, :string
    add_index :resource_pools, :ancestry

    id_range = ResourcePool.rails_sequence_range(ResourcePool.my_region_number)

    say_with_time("set resource pool ancestry from existing genealogy relationship resource information") do
      connection.execute(<<-SQL)
      UPDATE resource_pools
      SET ancestry = new_ancestry
      FROM (
        -- join to resources to convert rel.id to resource_pool.id (it is in resource_id column)
        -- ARRAY_AGG takes multiple rows and converts to an array
        SELECT ancestor_resources_for_resource_pools.resource_pool_id AS resource_pool_id,
        ARRAY_TO_STRING(ARRAY_AGG(res_rels.resource_id)::VARCHAR[], '/') AS new_ancestry
        FROM (
          -- get resource pool and associated ancestor rel_id
          -- unnest converts an array to multiple rows, 1 ancestor per row
          -- with ordinality, and order by relationships.indx make sure ancestors stay in the same order
          SELECT resource_pools.id AS resource_pool_id, relationships.id AS rel_id
          FROM resource_pools
          JOIN relationships a_rels ON a_rels.resource_id = resource_pools.id
          AND a_rels.relationship = 'genealogy'
          AND a_rels.resource_type = 'ResourcePool'
          LEFT JOIN LATERAL UNNEST(STRING_TO_ARRAY(a_rels.ancestry, '/')::BIGINT[])
          WITH ORDINALITY AS relationships(id, indx) ON TRUE
          WHERE resource_pools.id BETWEEN #{id_range.first} AND #{id_range.last}
          ORDER BY resource_pools.id, relationships.indx
        ) AS ancestor_resources_for_resource_pools
        JOIN relationships res_rels ON res_rels.id = ancestor_resources_for_resource_pools.rel_id AND res_rels.relationship = 'genealogy'
        GROUP BY ancestor_resources_for_resource_pools.resource_pool_id
      ) AS new_ancestors_for_resource_pools
      WHERE new_ancestors_for_resource_pools.resource_pool_id = resource_pools.id
      SQL
    end

    Relationship.where(:relationship => 'genealogy', :resource_type => 'ResourcePool', :resource_id => ResourcePool.all.select(:id)).delete_all
  end

  def down
    say_with_time("create relationship records from resource pool ancestry") do
      rps_with_ancestry = ResourcePool.where.not(:ancestry => nil)
      rps_with_ancestry.each do |rp|
        Relationship.create!(:relationship => 'genealogy', :resource_type => 'ResourcePool', :resource_id => rp.id, :ancestry => rp.ancestry)
      end

      remove_column :resource_pools, :ancestry
    end
  end
end
