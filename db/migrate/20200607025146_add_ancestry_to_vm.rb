class AddAncestryToVm < ActiveRecord::Migration[5.2]
  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
    has_many :all_relationships, :class_name => "AddAncestryToVm::Relationship", :dependent => :destroy, :as => :resource
    include ActiveRecord::IdRegions
  end

  class Relationship < ActiveRecord::Base
  end

  #
  # build sql that converts relationship ancestry with the id of the relationship to model-side ancestry with the id of the model
  #

  # def ancestry_resource_ids(relationship, model_class_name, id_range)
  #   Relationship.where(
  #     :relationship => relationship,
  #     :resource_type => model_class_name,
  #     :resource_id => id_range
  #   ).where.not(:ancestry => nil).flat_map do |a_rels|
  #     a_rels.ancestry.split('/').each_with_index.map { |rel_id, indx| [a_rels.resource_id, rel_id, indx] }
  #   end
  # end

  def ancestry_resource_ids(relationship, model_class_name, id_range)
    <<-SQL
    SELECT a_rels.resource_id AS src_id, relationships.id AS rel_id, relationships.indx AS rel_indx
    FROM   relationships a_rels
    LEFT JOIN LATERAL UNNEST(STRING_TO_ARRAY(a_rels.ancestry, '/')::BIGINT[])
    WITH ORDINALITY AS relationships(id, indx) ON TRUE
    WHERE  a_rels.relationship = '#{relationship}'
    AND    a_rels.resource_type = '#{model_class_name}'
    AND    a_rels.resource_id BETWEEN #{id_range.first} AND #{id_range.last}
    SQL
  end

  # def ancestry_src_ids(ancestry_resources)
  #   ancestry_resources.map do |rec|
  #     {
  #       src_id: rec.src_id,
  #       ancestry_src_id: Relationship.find(rec[1]).resource_id
  #     }
  #   end
  # end

  def ancestry_src_ids(ancestry_resources)
    <<-SQL
    SELECT ancestry_resources.src_id AS src_id, res_rels.resource_id AS ancestry_src_id
    FROM (#{ancestry_resources}) AS ancestry_resources
    JOIN relationships res_rels
    ON res_rels.id = ancestry_resources.rel_id
    ORDER BY ancestry_resources.src_id, ancestry_resources.rel_indx
    SQL
  end

  # def ancestry_of_src_ids_for_src(ancestry_sources)
  #   ancestry_sources.group_by { |rec| rec.src_id }.map do |src_id, recs|
  #     {
  #       src_id: src_id,
  #       new_ancestry: recs.map { |rec| rec.ancestry_src_id }.join('/')
  #     }
  #   end
  # end

  def ancestry_of_src_ids_for_src(ancestry_sources)
    <<-SQL
    SELECT ancestry_sources.src_id AS src_id,
           ARRAY_TO_STRING(ARRAY_AGG(ancestry_sources.ancestry_src_id)::VARCHAR[], '/') AS new_ancestry
    FROM (#{ancestry_sources}) AS ancestry_sources
    GROUP BY ancestry_sources.src_id
    SQL
  end

  # def update_src(model, new_ancestors)
  #   new_ancestors.each { |a| model.find(a[:src_id]).update(:ancestry => a[:new_ancestry]) }
  # end

  def update_src(new_ancestors)
    <<-SQL
    UPDATE vms
    SET ancestry = new_ancestry
    FROM (#{new_ancestors}) AS new_ancestors
    WHERE new_ancestors.src_id = vms.id
    SQL
  end

  def up
    add_column :vms, :ancestry, :string
    add_index :vms, :ancestry

    say_with_time("set vm ancestry from existing genealogy relationship resource information") do
      ancestry_resources = ancestry_resource_ids('genealogy', "VmOrTemplate", VmOrTemplate.rails_sequence_range(VmOrTemplate.my_region_number))
      ancestry_sources = ancestry_src_ids(ancestry_resources)
      new_ancestors = ancestry_of_src_ids_for_src(ancestry_sources)
      connection.execute(update_src(new_ancestors))
    end

    Relationship.where(:relationship => 'genealogy', :resource_type => 'VmOrTemplate', :resource_id => VmOrTemplate.all.select(:id)).delete_all
  end

  def down
    say_with_time("create relationship records from vm ancestry") do
      vms_with_ancestry = VmOrTemplate.where.not(:ancestry => nil)
      vms_with_ancestry.each do |vm|
        Relationship.create!(:relationship => 'genealogy', :resource_type => 'VmOrTemplate', :resource_id => vm.id, :ancestry => vm.ancestry)
      end

      remove_column :vms, :ancestry
    end
  end
end
