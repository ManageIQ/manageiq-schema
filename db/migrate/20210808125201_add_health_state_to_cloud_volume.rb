class AddHealthStateToCloudVolume < ActiveRecord::Migration[6.0]
  def change
    add_column :cloud_volumes, :health_state, :string
  end
end
