class AddConversionHostTable < ActiveRecord::Migration[5.0]
  def change
    create_table :conversion_hosts do |t|
      t.string :name
      t.string :address
      t.string :type
      t.string :resource_type
      t.bigint :resource_id
      t.timestamps
      t.index %w(resource_id resource_type)
    end
  end
end
