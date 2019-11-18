class AddTypeToResourcePools < ActiveRecord::Migration[5.1]
  def change
    add_column :resource_pools, :type, :string
  end
end
