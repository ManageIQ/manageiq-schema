class AddEmsRefToTenants < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :ems_ref, :string
  end
end
