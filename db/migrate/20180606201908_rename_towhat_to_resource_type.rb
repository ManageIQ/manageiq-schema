class RenameTowhatToResourceType < ActiveRecord::Migration[5.0]
  def change
    rename_column :miq_schedules, :towhat, :resource_type
  end
end
