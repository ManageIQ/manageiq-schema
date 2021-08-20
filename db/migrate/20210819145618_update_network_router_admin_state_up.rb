class UpdateNetworkRouterAdminStateUp < ActiveRecord::Migration[6.0]
  class NetworkRouter < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    change_column :network_routers, :admin_state_up,
      "BOOLEAN USING COALESCE(admin_state_up::BOOLEAN, FALSE)"

    change_column_default :network_routers, :admin_state_up, false
    change_column_null :network_routers, :admin_state_up, false
  end

  def down
    change_column_null :network_routers, :admin_state_up, true
    change_column_default :network_routers, :admin_state_up, nil

    change_column :network_routers, :admin_state_up, "varchar"
  end
end
