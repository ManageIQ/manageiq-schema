class RenameTowHatToTargetClassNameInMiqPolicyAndCondition < ActiveRecord::Migration[5.1]
  def change
    rename_column :miq_policies, :towhat, :target_class_name
    rename_column :conditions,   :towhat, :target_class_name
  end
end
