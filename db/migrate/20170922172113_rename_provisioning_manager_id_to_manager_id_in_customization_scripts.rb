class RenameProvisioningManagerIdToManagerIdInCustomizationScripts < ActiveRecord::Migration[5.0]
  def change
    rename_column :customization_scripts, :provisioning_manager_id, :manager_id
  end
end
