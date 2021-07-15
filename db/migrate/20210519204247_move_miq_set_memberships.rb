class MoveMiqSetMemberships < ActiveRecord::Migration[5.0]
  class Relationship < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqSetMembership < ActiveRecord::Base
  end

  def up
    say_with_time("Converting set relationships to miq_set_memberships") do
      # The `ancestry` column holds the id for the `relationship` record that
      # references the miq_set the parent record contains the miq_set object
      #
      # Because these are trivial trees (1 parent with 1 level of children),
      # the `miq_set_id` can be derived from the `resource_id` of the parent
      miq_set_id = "(SELECT rel2.resource_id FROM relationships rel2 WHERE rel2.id = rels.ancestry::bigint)"

      connection.execute(<<-SQL.squish)
        INSERT INTO miq_set_memberships (member_type, member_id, miq_set_id, created_at, updated_at)
          SELECT rels.resource_type, rels.resource_id, #{miq_set_id}, rels.created_at, rels.updated_at
          FROM relationships rels
          WHERE rels.relationship = 'membership' AND rels.ancestry IS NOT NULL
      SQL

      Relationship.where(:relationship => "membership").delete_all
    end
  end

  def down
    say_with_time("Converting miq_set_memberships to set relationships") do
      # Find the find the id for the `relationships` record that is from the
      # 'membership' relationship, `miq_set_id` that matches the `resource_id`,
      # and has a `ancestry` column value of NULL, all of which should be
      # created in the first query.
      ancestry_id = <<~ANCESTRY_ID.squish
        (
          SELECT rel2.id::varchar
          FROM relationships rel2
          WHERE rel2.relationship = 'membership'
            AND rel2.resource_type = set_mem.member_type || 'Set'
            AND rel2.resource_id = set_mem.miq_set_id
            AND rel2.ancestry IS NULL
          LIMIT 1
        )
      ANCESTRY_ID

      # First Query:   Add root nodes (only if children exist)
      connection.execute(<<~SQL.squish)
        INSERT INTO relationships (relationship, resource_type, resource_id, ancestry, created_at, updated_at)
          SELECT 'membership', set_mem.member_type || 'Set', set_mem.miq_set_id, NULL, set_mem.created_at, set_mem.updated_at
          FROM miq_set_memberships set_mem
          WHERE set_mem.miq_set_id IN (
            SELECT set_mem_2.miq_set_id
            FROM miq_set_memberships set_mem_2
            GROUP BY set_mem_2.miq_set_id
          );
      SQL

      # Second Query:  Add child nodes (based on root notes for ancestry column)
      connection.execute(<<~SQL.squish)
        INSERT INTO relationships (relationship, resource_type, resource_id, ancestry, created_at, updated_at)
          SELECT 'membership', set_mem.member_type, set_mem.member_id, #{ancestry_id}, set_mem.created_at, set_mem.updated_at
          FROM miq_set_memberships set_mem;
      SQL

      MiqSetMembership.delete_all
    end
  end
end
