class CreateConfigurationTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :configuration_templates do |t|
      t.bigint :ems_id
      t.string :external_id
      t.string :name
      t.string :description
      t.boolean :user_defined
      t.boolean :in_use
    end
  end
end
