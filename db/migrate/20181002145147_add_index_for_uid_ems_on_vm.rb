class AddIndexForUidEmsOnVm < ActiveRecord::Migration[5.0]
  def change
    add_index :vms, :uid_ems
  end
end
