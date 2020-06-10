class AddAncestryToVm < ActiveRecord::Migration[5.2]
  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
    has_many :all_relationships, :class_name => "AddAncestryToVm::Relationship", :dependent => :destroy, :as => :resource
  end

  class Vm < VmOrTemplate
    include ActiveRecord::IdRegions
  end

  class Relationship < ActiveRecord::Base
    belongs_to :vm, :class_name => 'AddAncestryToVm::VmOrTemplate', :foreign_key => :vm_id
  end

  def up
    add_column :vms, :ancestry, :string
    add_index :vms, :ancestry

    id_range = Vm.rails_sequence_range(Vm.my_region_number)

    say_with_time("set vm ancestry from existing genealogy relationship resource information") do
      connection.execute(<<-SQL)
      UPDATE vms
      SET ancestry = new_ancestry
      FROM (
        -- join to resources to convert rel.id to vm.id (it is in resource_id column)
        -- ARRAY_AGG takes multiple rows and converts to an array
        SELECT ancestor_resources_for_vms.vm_id AS vm_id,
        ARRAY_TO_STRING(ARRAY_AGG(res_rels.resource_id)::VARCHAR[], '/') AS new_ancestry
        FROM (
          -- get vm and associated ancestor rel_id
          -- unnest converts an array to multiple rows, 1 ancestor per row
          -- with ordinality, and order by relationships.indx make sure ancestors stay in the same order
          SELECT vms.id AS vm_id, relationships.id AS rel_id
          FROM vms
          JOIN relationships a_rels ON a_rels.resource_id = vms.id
          AND a_rels.relationship = 'genealogy'
          AND a_rels.resource_type = 'VmOrTemplate'
          LEFT JOIN LATERAL UNNEST(STRING_TO_ARRAY(a_rels.ancestry, '/')::BIGINT[])
          WITH ORDINALITY AS relationships(id, indx) ON TRUE
          WHERE vms.id BETWEEN #{id_range.first} AND #{id_range.last}
          ORDER BY vms.id, relationships.indx
        ) AS ancestor_resources_for_vms
        JOIN relationships res_rels ON res_rels.id = ancestor_resources_for_vms.rel_id AND res_rels.relationship = 'genealogy'
        GROUP BY ancestor_resources_for_vms.vm_id
      ) AS new_ancestors_for_vms
      WHERE new_ancestors_for_vms.vm_id = vms.id
      SQL
    end

    Relationship.where(:relationship => 'genealogy', :resource_type => 'VmOrTemplate', :resource_id => Vm.all.select(:id)).delete_all
  end

  def down
    say_with_time("create relationship records from vm ancestry") do
      vms_with_ancestry = Vm.where.not(:ancestry => nil)
      vms_with_ancestry.each do |vm|
        Relationship.create!(:relationship => 'genealogy', :resource_type => 'VmOrTemplate', :resource_id => vm.id, :ancestry => vm.ancestry)
      end

      remove_column :vms, :ancestry
    end
  end
end
