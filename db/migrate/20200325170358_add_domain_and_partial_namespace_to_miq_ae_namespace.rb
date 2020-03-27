require 'ancestry'

class AddDomainAndPartialNamespaceToMiqAeNamespace < ActiveRecord::Migration[5.1]
  class MiqAeNamespace < ActiveRecord::Base
    has_ancestry
  end

  def up
    add_column :miq_ae_namespaces, :domain_name, :string
    add_column :miq_ae_namespaces, :partial_namespace, :string
    add_index :miq_ae_namespaces, :domain_name
    add_index :miq_ae_namespaces, :partial_namespace

    say_with_time("Add domain_name and partial_namespace to MiqAeNamespaces") do
      MiqAeNamespace.find_each do |ns|
        if ns.root?
          ns.update(:domain_name => ns.name)
        else
          ns.update(:domain_name => ns.root.name, :partial_namespace => ns.path.pluck(:name).drop(1).join("/"))
        end
      end
    end
  end

  def down
    remove_index :miq_ae_namespaces, :column => :domain_name
    remove_index :miq_ae_namespaces, :column => :partial_namespace
    remove_column :miq_ae_namespaces, :domain_name
    remove_column :miq_ae_namespaces, :partial_namespace
  end
end
