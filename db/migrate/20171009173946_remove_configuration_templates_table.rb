class RemoveConfigurationTemplatesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :configuration_templates do |t|
      t.bigint :ems_id
      t.string :ems_ref
      t.string :name
      t.string :description
      t.boolean :user_defined
      t.boolean :in_use
    end
  end
end
