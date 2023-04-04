class AddPathAndFilenameToWorkflows < ActiveRecord::Migration[6.1]
  def change
    add_column :workflows, :file_path, :string
    add_column :workflows, :file_name, :string
  end
end
