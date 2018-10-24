class ChangeEmsRefToCaseInsensitive < ActiveRecord::Migration[5.0]
  def up
    enable_extension :citext
    change_column :vms, :ems_ref, :citext
  end

  def down
    disable_extension :citext
  end
end
