class DropBlueprints < ActiveRecord::Migration[5.0]
  def up
    drop_table :blueprints
    remove_column :dialogs,           :blueprint_id, :bigint
    remove_column :service_templates, :blueprint_id, :bigint
  end

  def down
    create_table :blueprints do |t|
      t.string :name
      t.string :description
      t.string :status
      t.string :version
      t.jsonb  :ui_properties

      t.timestamps
    end
    add_index :blueprints, :name
    add_index :blueprints, :status

    add_column :dialogs,           :blueprint_id, :bigint
    add_column :service_templates, :blueprint_id, :bigint
  end
end
