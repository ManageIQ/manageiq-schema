class ChangeEmsRefToCaseInsensitive < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext
    change_column :vms, :emsref, :citext
  end
end
