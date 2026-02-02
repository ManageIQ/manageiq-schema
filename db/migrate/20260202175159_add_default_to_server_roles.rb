class AddDefaultToServerRoles < ActiveRecord::Migration[7.2]
  def change
    add_column :server_roles, :default, :boolean, :default => false
  end
end
