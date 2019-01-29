class AddProvisionStateToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :provision_state, :string
  end
end
