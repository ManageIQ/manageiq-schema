class AddRequestsAndLimitsToPersistentVolumeClaims < ActiveRecord::Migration[5.0]
  def change
    add_column  :persistent_volume_claims, :requests, :text
    add_column  :persistent_volume_claims, :limits, :text
  end
end
