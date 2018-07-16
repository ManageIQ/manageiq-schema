class CreateCloudVolumeTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :cloud_volume_types do |t|
      t.text :description
      t.string :name
      t.string :type
      t.string :backend_name
      t.string :ems_ref
      t.bigint :ems_id
      t.boolean :public

      t.timestamps
    end
  end
end
