class RemoveToWhatColum < ActiveRecord::Migration[5.0]
  def change
    delete_column :miq_policies, :resource_type, :string
    delete_column :conditions,   :resource_type, :string
  end
end
