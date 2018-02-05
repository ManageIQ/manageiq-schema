class AddSwitchIdToHardwares < ActiveRecord::Migration[5.0]
  def change
    add_column :hardwares, :switch_id, :bigint
  end
end
