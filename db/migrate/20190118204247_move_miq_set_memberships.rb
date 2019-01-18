class MoveMiqSetMemberships < ActiveRecord::Migration[5.0]
  class Relationship < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqSetMembership < ActiveRecord::Base
  end

  def up
    say_with_time("Converting set relationships to miq_set_memberships") do
      # ancestry holds the id for the relationship record that references the set
      # the parent record contains the set object
      # because these are trivial trees, we can get the set_id from the resource_id of the parent
      miq_set_id = "(SELECT rel2.resource_id FROM relationships rel2 WHERE rel2.id = rels.ancestry::bigint)"

      connection.execute(<<-SQL)
        INSERT INTO miq_set_memberships (member_type, miq_set_id, member_id, created_at, updated_at)
          SELECT rels.resource_type, #{miq_set_id}, rels.resource_id, rels.created_at, rels.updated_at
          FROM relationships rels
          WHERE rels.relationship = 'membership' AND rels.ancestry IS NOT NULL
      SQL

      Relationship.where(:relationship => "membership").delete_all
    end
  end

  def down
    say_with_time("Converting miq_set_memberships to set relationships") do
      MiqSetMembership.all.each do |m|
        Relationship.create!(:relationship => "membership", :resource_type => m.member_type, :resource_id => m.member_id, :ancestry => m.miq_set_id)
      end

      MiqSetMembership.delete_all
    end
  end
end
