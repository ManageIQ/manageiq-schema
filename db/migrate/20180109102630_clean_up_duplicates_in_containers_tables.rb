class CleanUpDuplicatesInContainersTables < ActiveRecord::Migration[5.0]
  class ContainerBuild < ActiveRecord::Base; end
  class ContainerBuildPod < ActiveRecord::Base; end
  class ContainerGroup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end
  class ContainerLimit < ActiveRecord::Base; end
  class ContainerNode < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end
  class ContainerProject < ActiveRecord::Base; end
  class ContainerQuota < ActiveRecord::Base; end
  class ContainerReplicator < ActiveRecord::Base; end
  class ContainerRoute < ActiveRecord::Base; end
  class ContainerService < ActiveRecord::Base; end
  class ContainerTemplate < ActiveRecord::Base; end
  class PersistentVolumeClaim < ActiveRecord::Base; end

  class ContainerImage < ActiveRecord::Base; end
  class ContainerImageRegistry < ActiveRecord::Base; end

  class ContainerCondition < ActiveRecord::Base; end
  class SecurityContext < ActiveRecord::Base; end
  class ComputerSystem < ActiveRecord::Base; end
  class ContainerEnvVar < ActiveRecord::Base; end
  class ContainerLimitItem < ActiveRecord::Base; end
  class ContainerPortConfig < ActiveRecord::Base; end
  class ContainerQuotaScope < ActiveRecord::Base; end
  class ContainerQuotaItem < ActiveRecord::Base; end
  class ContainerServicePortConfig < ActiveRecord::Base; end
  class ContainerTemplateParameter < ActiveRecord::Base; end
  class ContainerVolume < ActiveRecord::Base; end
  class CustomAttribute < ActiveRecord::Base; end
  class Hardware < ActiveRecord::Base; end
  class OperatingSystem < ActiveRecord::Base; end

  class Container < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def cleanup_duplicate_data_delete_all(model, unique_index_columns)
    # 'ORDER BY id DESC' keeps the highest `id`. `ORDER BY id ASC` (more common case) would keep the lowest `id`.
    connection.execute <<-SQL
      DELETE FROM #{model.table_name}
        WHERE id IN (SELECT id
                      FROM (SELECT id, ROW_NUMBER() OVER (partition BY #{unique_index_columns.join(",")} ORDER BY id DESC) AS rnum
                             FROM #{model.table_name}) t
                      WHERE t.rnum > 1);
    SQL
  end

  UNIQUE_INDEXES_FOR_MODELS = {
    # Just having :ems_id & :ems_ref
    ContainerBuild             => [:ems_id, :ems_ref],
    ContainerBuildPod          => [:ems_id, :ems_ref],
    ContainerGroup             => [:ems_id, :ems_ref],
    ContainerLimit             => [:ems_id, :ems_ref],
    ContainerNode              => [:ems_id, :ems_ref],
    ContainerProject           => [:ems_id, :ems_ref],
    ContainerQuota             => [:ems_id, :ems_ref],
    ContainerReplicator        => [:ems_id, :ems_ref],
    ContainerRoute             => [:ems_id, :ems_ref],
    ContainerService           => [:ems_id, :ems_ref],
    ContainerTemplate          => [:ems_id, :ems_ref],
    Container                  => [:ems_id, :ems_ref],
    PersistentVolumeClaim      => [:ems_id, :ems_ref],
    # Having :ems_id but not ems_ref
    ContainerImage             => [:ems_id, :image_ref],
    ContainerImageRegistry     => [:ems_id, :host, :port],
    # Nested tables, not having :ems_id and the foreign_key is a part of the unique index
    ContainerCondition         => [:container_entity_id, :container_entity_type, :name],
    SecurityContext            => [:resource_id, :resource_type],
    ComputerSystem             => [:managed_entity_id, :managed_entity_type],
    ContainerEnvVar            => [:container_id, :name, :value, :field_path],
    ContainerLimitItem         => [:container_limit_id, :resource, :item_type],
    ContainerPortConfig        => [:container_id, :ems_ref],
    ContainerQuotaScope        => [:container_quota_id, :scope],
    ContainerQuotaItem         => [:container_quota_id, :resource],
    ContainerServicePortConfig => [:container_service_id, :name],
    ContainerTemplateParameter => [:container_template_id, :name],
    ContainerVolume            => [:parent_id, :parent_type, :name],
    CustomAttribute            => [:resource_id, :resource_type, :name, :unique_name, :section, :source],
    Hardware                   => [:vm_or_template_id, :host_id, :computer_system_id],
    OperatingSystem            => [:vm_or_template_id, :host_id, :computer_system_id],
  }.freeze

  def up
    UNIQUE_INDEXES_FOR_MODELS.each do |model, unique_indexes_columns|
      say_with_time("Cleanup duplicate data for model #{model}") do
        cleanup_duplicate_data_delete_all(model, unique_indexes_columns)
      end
    end
  end
end
