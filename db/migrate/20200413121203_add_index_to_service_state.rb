class AddIndexToServiceState < ActiveRecord::Migration[5.1]
  def change
    add_index :services, :lifecycle_state
  end
end
