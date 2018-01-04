class CreateTransformationMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :transformation_mappings do |t|
      t.string :name
      t.string :description
      t.string :comments
      t.string :state
      t.jsonb  :options, :default => {}
      t.bigint :tenant_id
      t.timestamps
    end
  end
end
