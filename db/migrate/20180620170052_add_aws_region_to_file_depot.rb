class AddAwsRegionToFileDepot < ActiveRecord::Migration[5.0]
  def change
    add_column :file_depots, :aws_region, :string
  end
end
