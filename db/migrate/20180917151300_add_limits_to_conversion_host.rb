class AddLimitsToConversionHost < ActiveRecord::Migration[5.0]
  def change
    add_column :conversion_hosts, :concurrent_transformation_limit, :string
    add_column :conversion_hosts, :cpu_limit, :string
    add_column :conversion_hosts, :memory_limit, :string
    add_column :conversion_hosts, :network_limit, :string
    add_column :conversion_hosts, :blockio_limit, :string
  end
end
