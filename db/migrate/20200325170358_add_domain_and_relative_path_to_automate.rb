require 'ancestry'

class AddDomainAndRelativePathToAutomate < ActiveRecord::Migration[5.1]
  class MiqAeDomain < ActiveRecord::Base
    self.table_name = 'miq_ae_namespaces'
  end

  class MiqAeNamespace < ActiveRecord::Base
    has_many :ae_classes, :class_name => "AddDomainAndRelativePathToAutomate::MiqAeClass", :foreign_key => :namespace_id
    has_ancestry
  end

  class MiqAeClass < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    belongs_to :ae_namespace, :class_name => "AddDomainAndRelativePathToAutomate::MiqAeNamespace", :foreign_key => :namespace_id
  end

  class MiqAeInstance < ActiveRecord::Base
    belongs_to :ae_class, :class_name => "AddDomainAndRelativePathToAutomate::MiqAeClass", :foreign_key => :class_id
  end

  class MiqAeMethod < ActiveRecord::Base
    belongs_to :ae_class, :class_name => "AddDomainAndRelativePathToAutomate::MiqAeClass", :foreign_key => :class_id
  end

  def populate_children(nodes)
    nodes.each do |parent, children|
      children.keys.each do |child|
        child.update!(:relative_path => "#{parent.relative_path}/#{child.name}", :domain_id => parent.domain_id)
      end
      populate_children(children)
    end
  end

  # for miq_ae_class, object_name is nil
  #   joins namespace's relative_path, '/', miq_ae_classes' name
  #   for '$' domain, namespace is absent, so don't output the '/'
  # for miq_ae_instance/miq_ae_method, object_name has table name
  #   joins namespace's relative_path, '/', class's name, '/', object_name's name
  #   need to join from object_name to ae_class
  #   for '$' domain, namespace is absent, so don't output the first '/'
  #
  def relative_path_sql(object_name = nil)
    optional_slash_sql = "CASE WHEN miq_ae_namespaces.relative_path IS NULL THEN '' ELSE '/' END"
    columns = ["miq_ae_namespaces.relative_path", optional_slash_sql, "miq_ae_classes.name"]
    columns += ["'/'", "#{object_name}.name"] if object_name

    sql = MiqAeNamespace.select("concat(#{columns.join(', ')})")
    if object_name
      sql.joins(:ae_classes).where("#{object_name}.class_id = miq_ae_classes.id").to_sql
    else
      sql.where("miq_ae_namespaces.id = miq_ae_classes.namespace_id").to_sql
    end
  end

  # usually it is structured as /domain/namespace/class/method, namespace has domain_id set
  # for '$' domain, it is structured like /$/class/method, namespace is the domain, domain_id is absent, so uses id
  def domain_id_sql(object_name = nil)
    sql = MiqAeNamespace.select("COALESCE(miq_ae_namespaces.domain_id, miq_ae_namespaces.id)")
    if object_name
      sql.joins(:ae_classes).where("#{object_name}.class_id = miq_ae_classes.id").to_sql
    else
      sql.where("miq_ae_namespaces.id = miq_ae_classes.namespace_id").to_sql
    end
  end

  def up
    add_column :miq_ae_namespaces, :domain_id, :bigint
    add_column :miq_ae_namespaces, :relative_path, :string
    add_index :miq_ae_namespaces, :relative_path

    add_column :miq_ae_classes, :domain_id, :bigint
    add_column :miq_ae_classes, :relative_path, :string
    add_index :miq_ae_classes, :relative_path

    add_column :miq_ae_instances, :domain_id, :bigint
    add_column :miq_ae_instances, :relative_path, :string
    add_index :miq_ae_instances, :relative_path

    add_column :miq_ae_methods, :domain_id, :bigint
    add_column :miq_ae_methods, :relative_path, :string
    add_index :miq_ae_methods, :relative_path

    say_with_time("Add domain_id and relative_path to MiqAeNamespace") do
      MiqAeNamespace.where(:ancestry => nil).each do |domain|
        children = domain.descendants.arrange
        children.keys.each do |child|
          child.update!(:domain_id => domain.id, :relative_path => child.name)
        end
        populate_children(children)
      end
    end

    say_with_time("Add domain_id and relative_path to MiqAeClass") do
      MiqAeClass.update_all("domain_id = (#{domain_id_sql}), relative_path = (#{relative_path_sql})")
    end

    say_with_time("Add domain_id and relative_path to MiqAeInstance") do
      MiqAeInstance.update_all("domain_id = (#{domain_id_sql("miq_ae_instances")}), relative_path = (#{relative_path_sql("miq_ae_instances")})")
    end

    say_with_time("Add domain_id and relative_path to MiqAeMethod") do
      MiqAeMethod.update_all("domain_id = (#{domain_id_sql("miq_ae_methods")}), relative_path = (#{relative_path_sql("miq_ae_methods")})")
    end
  end

  def down
    remove_index :miq_ae_namespaces, :column => :relative_path
    remove_column :miq_ae_namespaces, :domain_id
    remove_column :miq_ae_namespaces, :relative_path

    remove_index :miq_ae_classes, :column => :relative_path
    remove_column :miq_ae_classes, :domain_id
    remove_column :miq_ae_classes, :relative_path

    remove_index :miq_ae_instances, :column => :relative_path
    remove_column :miq_ae_instances, :domain_id
    remove_column :miq_ae_instances, :relative_path

    remove_index :miq_ae_methods, :column => :relative_path
    remove_column :miq_ae_methods, :domain_id
    remove_column :miq_ae_methods, :relative_path
  end
end
