class AddEmsRefToGuestDevice < ActiveRecord::Migration[5.1]
  def change
    add_column :guest_devices, :ems_ref, :string
  end
end
