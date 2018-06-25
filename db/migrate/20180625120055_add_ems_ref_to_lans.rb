class AddEmsRefToLans < ActiveRecord::Migration[5.0]
  def change
    add_column :lans, :ems_ref, :string
  end
end
