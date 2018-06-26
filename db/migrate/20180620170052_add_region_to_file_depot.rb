class AddRegionToFileDepot < ActiveRecord::Migration[5.0]
  def change
    add_column :file_depots, :region, :string
  end
end
