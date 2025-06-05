class DropTenantUseConfigForAttributes < ActiveRecord::Migration[7.0]
  def change
    remove_column :tenants, :use_config_for_attributes, :boolean
  end
end
