class ConditionRenameTowhatToResourceType < ActiveRecord::Migration[5.0]
  def change
    rename_column :conditions, :towhat, :resource_type
  end
end
