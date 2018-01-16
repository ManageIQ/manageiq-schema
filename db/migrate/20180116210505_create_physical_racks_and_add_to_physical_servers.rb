class CreatePhysicalRacksAndAddToPhysicalServers < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_racks do |t|
      t.bigint :ems_id
      t.string :uid_ems
      t.string :name
      t.timestamps
    end

    add_column :physical_servers, :physical_rack_id, :bigint
  end
end
