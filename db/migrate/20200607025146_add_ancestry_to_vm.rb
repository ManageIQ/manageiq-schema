class AddAncestryToVm < ActiveRecord::Migration[5.2]
  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
    has_many :all_relationships, :class_name => "AddAncestryToVm::Relationship", :dependent => :destroy, :as => :resource
    include ActiveRecord::IdRegions
  end

  class Relationship < ActiveRecord::Base
  end

  def up
    add_column :vms, :ancestry, :string
    add_index :vms, :ancestry

    say_with_time("set vm ancestry from existing genealogy relationship resource information") do
      transfer_relationships_to_ancestry(VmOrTemplate, 'VmOrTemplate', 'genealogy')
    end

    Relationship.where(:relationship => 'genealogy', :resource_type => 'VmOrTemplate', :resource_id => VmOrTemplate.all.select(:id)).delete_all
  end

  def down
    say_with_time("create relationship records from vm ancestry") do
      create_relationships_from_ancestry(VmOrTemplate.where(:template => false), Relationship, 'VmOrTemplate', 'genealogy')
    end

    remove_column :vms, :ancestry
  end

  # src is relationship, dest is vm
  def transfer_relationships_to_ancestry(dest_model, resource_type, relationship)
    ancestry_resources = ancestry_resource_ids(relationship, resource_type, dest_model.rails_sequence_range(dest_model.my_region_number))
    ancestry_sources = ancestry_src_ids(ancestry_resources)
    new_ancestors = ancestry_of_src_ids_for_src(ancestry_sources)
    connection.execute(update_src(new_ancestors, dest_model))
  end

  # src is vm, dest is relationship
  def create_relationships_from_ancestry(src_model, dest_model, resource_type, relationship)
    children = src_model.select("ancestry::bigint").where("ancestry NOT LIKE '%/%'")
    rels = src_model.where.not(:ancestry => nil).or(src_model.where(:id => children)).map do |obj|
      dest_model.create!(:relationship  => relationship,
                         :resource_type => resource_type,
                         :resource_id   => obj.id,
                         :ancestry      => obj.ancestry)
    end.index_by(&:resource_id)
    rels.each do |_, r|
      next if r.ancestry.nil?

      ancestry = r.ancestry.split('/').map { |rel| rels[rel.to_i].id }.join('/')
      r.update!(:ancestry => ancestry)
    end
  end

  private

  def ancestry_resource_ids(relationship, resource_type, id_range)
    <<-SQL
    SELECT a_rels.resource_id AS src_id, relationships.id AS rel_id, relationships.indx AS rel_indx
    FROM   relationships a_rels
    LEFT JOIN LATERAL UNNEST(STRING_TO_ARRAY(a_rels.ancestry, '/')::BIGINT[])
    WITH ORDINALITY AS relationships(id, indx) ON TRUE
    WHERE  a_rels.relationship = '#{relationship}'
    AND    a_rels.resource_type = '#{resource_type}'
    AND    a_rels.resource_id BETWEEN #{id_range.first} AND #{id_range.last}
    SQL

    # The above is a pure-SQL version of this similar Ruby code:
    #
    #   Relationship.where(
    #     :relationship => relationship,
    #     :resource_type => resource_type,
    #     :resource_id => id_range
    #   ).where.not(:ancestry => nil).flat_map do |a_rels|
    #     a_rels.ancestry.split('/').each_with_index.map { |rel_id, indx| [a_rels.resource_id, rel_id, indx] }
    #   end
  end

  def ancestry_src_ids(ancestry_resources)
    <<-SQL
    SELECT ancestry_resources.src_id AS src_id, res_rels.resource_id AS ancestry_src_id
    FROM (#{ancestry_resources}) AS ancestry_resources
    JOIN relationships res_rels
    ON res_rels.id = ancestry_resources.rel_id
    ORDER BY ancestry_resources.src_id, ancestry_resources.rel_indx
    SQL

    # The above is a pure-SQL version of this similar Ruby code:
    #
    #   ancestry_resources.map do |rec|
    #     {
    #       src_id: rec.src_id,
    #       ancestry_src_id: Relationship.find(rec[1]).resource_id
    #     }
    #   end
  end

  def ancestry_of_src_ids_for_src(ancestry_sources)
    <<-SQL
    SELECT ancestry_sources.src_id AS src_id,
           ARRAY_TO_STRING(ARRAY_AGG(ancestry_sources.ancestry_src_id)::VARCHAR[], '/') AS new_ancestry
    FROM (#{ancestry_sources}) AS ancestry_sources
    GROUP BY ancestry_sources.src_id
    SQL

    # The above is a pure-SQL version of this similar Ruby code:
    #
    #   ancestry_sources.group_by { |rec| rec.src_id }.map do |src_id, recs|
    #     {
    #       src_id: src_id,
    #       new_ancestry: recs.map { |rec| rec.ancestry_src_id }.join('/')
    #     }
    #   end
  end

  def update_src(new_ancestors, model)
    table_name = model.table_name
    <<-SQL
    UPDATE #{table_name}
    SET ancestry = new_ancestry
    FROM (#{new_ancestors}) AS new_ancestors
    WHERE new_ancestors.src_id = #{table_name}.id
    SQL

    # The above is a(n almost) pure-SQL version of this similar Ruby code:
    #
    #   new_ancestors.each { |a| model.find(a[:src_id]).update(:ancestry => a[:new_ancestry]) }
  end
end
