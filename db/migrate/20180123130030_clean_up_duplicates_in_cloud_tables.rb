class CleanUpDuplicatesInCloudTables < ActiveRecord::Migration[5.0]
  class AvailabilityZone < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudService < ApplicationRecord; end
  class CloudTenant < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudObjectStoreContainer < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudObjectStoreObject < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudNetwork < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudVolume < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudVolumeBackup < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudVolumeSnapshot < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class CloudResourceQuota < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class Flavor < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class ResourceGroup < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class HostAggregate < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class OrchestrationTemplate < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class OrchestrationStack < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end
  class Vm < ApplicationRecord
    self.inheritance_column = :_type_disabled
  end

  # class OrchestrationTemplateCatalog < ApplicationRecord; end # FIXME
  # class AuthKeyPair < ApplicationRecord; end # FIXME

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
    CloudService              => %i(ems_id ems_ref),
    ResourceGroup             => %i(ems_id ems_ref),
    CloudTenant               => %i(ems_id ems_ref),
    Flavor                    => %i(ems_id ems_ref),
    AvailabilityZone          => %i(ems_id ems_ref),
    HostAggregate             => %i(ems_id ems_ref),
    OrchestrationTemplate     => %i(ems_id ems_ref),
    OrchestrationStack        => %i(ems_id ems_ref),
    CloudVolume               => %i(ems_id ems_ref),
    CloudVolumeBackup         => %i(ems_id ems_ref),
    CloudVolumeSnapshot       => %i(ems_id ems_ref),
    CloudResourceQuota        => %i(ems_id ems_ref),
    CloudObjectStoreContainer => %i(ems_id ems_ref),
    CloudObjectStoreObject    => %i(ems_id ems_ref),
    Vm                        => %i(ems_id ems_ref),
  }.freeze

  def up
    UNIQUE_INDEXES_FOR_MODELS.each do |model, unique_indexes_columns|
      say_with_time("Cleanup duplicate data for model #{model}") do
        cleanup_duplicate_data_delete_all(model, unique_indexes_columns)
      end
    end
  end
end
