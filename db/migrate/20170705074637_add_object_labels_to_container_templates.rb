class AddObjectLabelsToContainerTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :container_templates, :object_labels, :text
  end
end
