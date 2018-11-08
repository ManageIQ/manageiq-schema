class RenameTowHatToResourceTypeInMiqPolicyAndCondition < ActiveRecord::Migration[5.0]
  def change
    rename_column :miq_policies, :towhat, :resource_type
    rename_column :conditions,   :towhat, :resource_type
  end
end
