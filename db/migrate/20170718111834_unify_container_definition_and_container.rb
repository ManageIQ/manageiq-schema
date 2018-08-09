class UnifyContainerDefinitionAndContainer < ActiveRecord::Migration[5.0]
  class ContainerDefinition < ActiveRecord::Base
    has_many :container_port_configs, :class_name => 'UnifyContainerDefinitionAndContainer::ContainerPortConfig'
    has_many :container_env_vars, :class_name => 'UnifyContainerDefinitionAndContainer::ContainerEnvVar'
    has_one :security_context, :as => :resource
    has_one :container, :class_name => 'UnifyContainerDefinitionAndContainer::Container'
  end

  class Container < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    belongs_to :container_definition, :class_name => 'UnifyContainerDefinitionAndContainer::ContainerDefinition'
  end

  class SecurityContext < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    belongs_to :resource, :polymorphic => true
  end

  class ContainerEnvVar < ActiveRecord::Base
    belongs_to :container_definition, :class_name => 'UnifyContainerDefinitionAndContainer::ContainerDefinition'
  end

  class ContainerPortConfig < ActiveRecord::Base
    belongs_to :container_definition, :class_name => 'UnifyContainerDefinitionAndContainer::ContainerDefinition'
  end

  class MiqQueue < ActiveRecord::Base
  end

  def up
    # attributes
    add_column :containers, :image,              :string
    add_column :containers, :image_pull_policy,  :string
    add_column :containers, :memory,             :string
    add_column :containers, :cpu_cores,          :float
    add_column :containers, :container_group_id, :bigint
    add_column :containers, :privileged,         :boolean
    add_column :containers, :run_as_user,        :bigint
    add_column :containers, :run_as_non_root,    :boolean
    add_column :containers, :capabilities_add,   :string
    add_column :containers, :capabilities_drop,  :string
    add_column :containers, :command,            :text

    say_with_time("Copying over columns from container_definition to container") do
      %w(image image_pull_policy memory cpu_cores container_group_id privileged
         run_as_user run_as_non_root capabilities_add capabilities_drop command).each do |column|
        connection.execute <<-SQL
          UPDATE containers SET #{column} = subquery.#{column}
          FROM (SELECT id, #{column} FROM container_definitions) AS subquery
          WHERE subquery.id = containers.container_definition_id
        SQL
      end
    end

    subquery_containers = <<-SQL
      SELECT id, container_definition_id FROM containers
    SQL

    say_with_time("switch container_definition_id with container_id for container_port_configs") do
      connection.execute <<-SQL
        UPDATE container_port_configs
        SET container_definition_id = subquery.id
        FROM (#{subquery_containers}) AS subquery
        WHERE subquery.container_definition_id = container_port_configs.container_definition_id
      SQL
    end

    say_with_time("switch container_definition_id with container_id for container_port_configs") do
      connection.execute <<-SQL
        UPDATE container_env_vars SET container_definition_id = subquery.id
        FROM (#{subquery_containers}) AS subquery
        WHERE subquery.container_definition_id = container_env_vars.container_definition_id
      SQL
    end

    say_with_time("switch resource_id with container_id, resource_type to 'Container' for security_contexts") do
      container_value = connection.quote('Container')
      container_definition_value = connection.quote('ContainerDefinition')

      connection.execute <<-SQL
        UPDATE security_contexts
        SET resource_type = #{container_value}, resource_id = subquery.id
        FROM (#{subquery_containers}) AS subquery
        WHERE subquery.container_definition_id = security_contexts.resource_id AND security_contexts.resource_type = #{container_definition_value}
      SQL
    end

    MiqQueue.where(:method_name => "purge_timer", :class_name => 'ContainerDefinition').destroy_all

    # relationships
    rename_column :container_port_configs, :container_definition_id, :container_id
    rename_column :container_env_vars, :container_definition_id, :container_id

    remove_column :containers, :container_definition_id
    drop_table :container_definitions
  end

  def down
    create_table :container_definitions do |t|
      t.belongs_to :ems, :type => :bigint       # reconstructed columns
      t.string     :ems_ref
      t.bigint     :old_ems_id
      t.timestamp  :deleted_on
      t.string     :name
      t.string     :image                       # copied over columns
      t.string     :image_pull_policy
      t.string     :memory
      t.float      :cpu_cores
      t.belongs_to :container_group, :type => :bigint
      t.boolean    :privileged
      t.bigint     :run_as_user
      t.boolean    :run_as_non_root
      t.string     :capabilities_add
      t.string     :capabilities_drop
      t.text       :command
      t.bigint     :container_id                # temp column
    end

    add_index :container_definitions, :deleted_on

    add_column :containers, :container_definition_id, :bigint

    say_with_time("populate container_definitions. use container_id to keep relation to containers") do
      insert_statement = "INSERT INTO container_definitions (container_id, ems_id, ems_ref, old_ems_id, deleted_on, name, image,
                                                           image_pull_policy, memory, cpu_cores, container_group_id,
                                                           privileged, run_as_user, run_as_non_root, capabilities_add,
                                                           capabilities_drop, command)
                        SELECT id, ems_id, ems_ref, old_ems_id, deleted_on, name, image, image_pull_policy, memory, cpu_cores,
                               container_group_id, privileged, run_as_user, run_as_non_root, capabilities_add,
                               capabilities_drop, command
                        FROM   containers"
      ActiveRecord::Base.connection.execute(insert_statement)
    end

    say_with_time("use container_id to join tables and update container_definition_id in containers") do
      update_statement = "UPDATE containers
                          SET container_definition_id = (SELECT container_definitions.id
                                                         FROM container_definitions
                                                         WHERE containers.id = container_definitions.container_id)"
      ActiveRecord::Base.connection.execute(update_statement)
    end

    # finally, remove the temp column
    remove_column :container_definitions, :container_id

    containers = Arel::Table.new(:containers)
    say_with_time("switch container_definition_id with container_id for container_port_configs") do
      port_configs = Arel::Table.new(:container_port_configs)
      join_sql = containers.project(containers[:container_definition_id])
                           .where(containers[:id].eq(port_configs[:container_id])).to_sql
      ContainerPortConfig.update_all("container_id = (#{join_sql})")
    end

    say_with_time("switch container_definition_id with container_id for for container_env_vars") do
      env_vars = Arel::Table.new(:container_env_vars)
      join_sql = containers.project(containers[:container_definition_id])
                           .where(containers[:id].eq(env_vars[:container_id])).to_sql
      ContainerEnvVar.update_all("container_id = (#{join_sql})")
    end

    say_with_time("swtich resource_id with container_id, resource_type to 'Container' for security_contexts") do
      security_contexts = Arel::Table.new(:security_contexts)
      join_sql = containers.project(containers[:container_definition_id])
                           .where(containers[:id].eq(security_contexts[:resource_id])
                           .and(security_contexts[:resource_type].eq(Arel::Nodes::Quoted.new('Container')))).to_sql
      SecurityContext.where(:resource_type => 'Container').update_all("resource_type = 'ContainerDefinition', resource_id = (#{join_sql})")
    end

    # relationships
    rename_column :container_port_configs, :container_id, :container_definition_id
    rename_column :container_env_vars, :container_id, :container_definition_id

    # attributes
    remove_column :containers, :image
    remove_column :containers, :image_pull_policy
    remove_column :containers, :memory
    remove_column :containers, :cpu_cores
    remove_column :containers, :container_group_id
    remove_column :containers, :privileged
    remove_column :containers, :run_as_user
    remove_column :containers, :run_as_non_root
    remove_column :containers, :capabilities_add
    remove_column :containers, :capabilities_drop
    remove_column :containers, :command
  end
end
