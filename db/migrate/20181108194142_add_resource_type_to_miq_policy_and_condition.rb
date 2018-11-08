class AddResourceTypeToMiqPolicyAndCondition < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_policies, :resource_type, :string
    add_column :conditions,   :resource_type, :string
  end
end
