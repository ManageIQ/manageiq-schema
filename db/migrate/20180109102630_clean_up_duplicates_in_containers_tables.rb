class CleanUpDuplicatesInContainersTables < ActiveRecord::Migration[5.0]
  class ContainerBuild < ApplicationRecord; end
  class ContainerBuildPod < ApplicationRecord; end
  class ContainerGroup < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class ContainerLimit < ApplicationRecord; end
  class ContainerNode < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class ContainerProject < ApplicationRecord; end
  class ContainerQuota < ApplicationRecord; end
  class ContainerReplicator < ApplicationRecord; end
  class ContainerRoute < ApplicationRecord; end
  class ContainerService < ApplicationRecord; end
  class ContainerTemplate < ApplicationRecord; end
  class PersistentVolumeClaim < ApplicationRecord; end

  class ContainerImage < ApplicationRecord; end
  class ContainerImageRegistry < ApplicationRecord; end

  class ContainerCondition < ApplicationRecord; end
  class SecurityContext < ApplicationRecord; end
  class Tagging < ApplicationRecord; end
  class ComputerSystem < ApplicationRecord; end
  class ContainerEnvVar < ApplicationRecord; end
  class ContainerLimitItem < ApplicationRecord; end
  class ContainerPortConfig < ApplicationRecord; end
  class ContainerQuotaScope < ApplicationRecord; end
  class ContainerQuotaItem < ApplicationRecord; end
  class ContainerServicePortConfig < ApplicationRecord; end
  class ContainerTemplateParameter < ApplicationRecord; end
  class ContainerVolume < ApplicationRecord; end
  class CustomAttribute < ApplicationRecord; end
  class Hardware < ApplicationRecord; end
  class OperatingSystem < ApplicationRecord; end

  class Container < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end

  def cleanup_duplicate_data_delete_all(model, unique_index_columns)
    # 'ORDER BY id DESC' keeps the highest `id`. `ORDER BY id ASC` (more common case) would keep the lowest `id`.
    query = <<-SQL
      DELETE FROM #{model.table_name}
        WHERE id IN (SELECT id
                      FROM (SELECT id, ROW_NUMBER() OVER (partition BY #{unique_index_columns.join(",")} ORDER BY id DESC) AS rnum
                             FROM #{model.table_name}) t
                      WHERE t.rnum > 1);
    SQL
    connection.execute(query)
  end

  UNIQUE_INDEXES_FOR_MODELS = {
    # Just having :ems_id & :ems_ref
    ContainerBuild             => %i(ems_id ems_ref),
    ContainerBuildPod          => %i(ems_id ems_ref),
    ContainerGroup             => %i(ems_id ems_ref),
    ContainerLimit             => %i(ems_id ems_ref),
    ContainerNode              => %i(ems_id ems_ref),
    ContainerProject           => %i(ems_id ems_ref),
    ContainerQuota             => %i(ems_id ems_ref),
    ContainerReplicator        => %i(ems_id ems_ref),
    ContainerRoute             => %i(ems_id ems_ref),
    ContainerService           => %i(ems_id ems_ref),
    ContainerTemplate          => %i(ems_id ems_ref),
    Container                  => %i(ems_id ems_ref),
    PersistentVolumeClaim      => %i(ems_id ems_ref),
    # Having :ems_id but not ems_ref
    ContainerImage             => %i(ems_id image_ref),
    ContainerImageRegistry     => %i(ems_id host port),
    # Nested tables, not having :ems_id and the foreign_key is a part of the unique index
    ContainerCondition         => %i(container_entity_id container_entity_type name),
    SecurityContext            => %i(resource_id resource_type),
    Tagging                    => %i(taggable_id taggable_type tag_id),
    ComputerSystem             => %i(managed_entity_id managed_entity_type),
    ContainerEnvVar            => %i(container_id name value field_path),
    ContainerLimitItem         => %i(container_limit_id resource item_type),
    ContainerPortConfig        => %i(container_id ems_ref),
    ContainerQuotaItem         => %i(container_quota_id resource quota_desired quota_enforced quota_observed),
    ContainerQuotaScope        => %i(container_quota_id scope),
    ContainerServicePortConfig => %i(container_service_id name),
    ContainerTemplateParameter => %i(container_template_id name),
    ContainerVolume            => %i(parent_id parent_type ems_ref name),
    CustomAttribute            => %i(resource_id resource_type name section source),
    Hardware                   => %i(vm_or_template_id host_id computer_system_id),
    OperatingSystem            => %i(vm_or_template_id host_id computer_system_id),
  }.freeze

  def up
    UNIQUE_INDEXES_FOR_MODELS.each do |model, unique_indexes_columns|
      say_with_time("Cleanup duplicate data for model #{model}") do
        cleanup_duplicate_data_delete_all(model, unique_indexes_columns)
      end
    end
  end
end
