class RenameContainerLabelTagMapping < ActiveRecord::Migration[5.2]
  def change
    rename_table :container_label_tag_mappings, :provider_tag_mappings
  end
end
