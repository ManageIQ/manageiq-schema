class RenameServiceState < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :state, :lifecycle_state
  end
end
