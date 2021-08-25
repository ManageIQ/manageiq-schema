class DefaultAdminStateUp < ActiveRecord::Migration[6.0]
  def up
    change_column_default :network_ports, :admin_state_up, false

    change_column_null :network_routers, :admin_state_up, true
  end

  def down
    change_column_default :network_ports, :admin_state_up, false

    change_column_null :network_routers, :admin_state_up, false
  end
end
