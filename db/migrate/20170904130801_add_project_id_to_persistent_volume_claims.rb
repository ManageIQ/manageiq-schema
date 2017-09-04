class AddProjectIdToPersistentVolumeClaims < ActiveRecord::Migration[5.0]
  def change
    add_column :persistent_volume_claims, :container_project_id, :bigint
  end
end
