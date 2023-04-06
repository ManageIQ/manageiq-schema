class AddDescriptionToWorkflows < ActiveRecord::Migration[6.1]
  def change
    add_column :workflows, :description, :string
  end
end
