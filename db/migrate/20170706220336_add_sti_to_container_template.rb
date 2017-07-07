class AddStiToContainerTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :container_templates, :type, :string
  end
end
