require 'ancestry'

class AddAncestryToMiqAeNamespace < ActiveRecord::Migration[5.1]
  class MiqAeNamespace < ActiveRecord::Base
    has_ancestry
  end

  def up
    add_column :miq_ae_namespaces, :ancestry, :string
    add_index :miq_ae_namespaces, :ancestry

    say_with_time("Converting MiqAeNamespaces from parent_id to ancestry") do
      MiqAeNamespace.build_ancestry_from_parent_ids!
    end

    remove_index :miq_ae_namespaces, :column => :parent_id
    remove_column :miq_ae_namespaces, :parent_id
  end

  def down
    add_column :miq_ae_namespaces, :parent_id, :bigint
    add_index :miq_ae_namespaces, :parent_id

    say_with_time("Converting MiqAeNamespaces from ancestry to parent_id") do
      MiqAeNamespace.update_all("parent_id = CAST(regexp_replace(ancestry, '.*/', '') AS bigint)")
    end

    remove_index :miq_ae_namespaces, :column => :ancestry
    remove_column :miq_ae_namespaces, :ancestry
  end
end
