class CreateTransformationMappingItems < ActiveRecord::Migration[5.0]
  def change
    create_table :transformation_mapping_items do |t|
      t.bigint :source_id
      t.string :source_type
      t.bigint :destination_id
      t.string :destination_type
      t.bigint :transformation_mapping_id
      t.jsonb  :options, :default => {}
      t.timestamps
    end

    add_index :transformation_mapping_items, :transformation_mapping_id
  end
end
