class CreateAutomateWorkspaces < ActiveRecord::Migration[5.0]
  def change
    create_table :automate_workspaces do |t|
      t.string :guid
      t.jsonb :output
      t.jsonb :input
    end
  end
end
