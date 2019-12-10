class DropEmsRefFromHostStorage < ActiveRecord::Migration[5.1]
  def change
    remove_column :host_storages, :ems_ref, :string
  end
end
