class DropIsoDatastore < ActiveRecord::Migration[6.1]
  def up
    say_with_time("Drop IsoDatastore table") do
      remove_reference :iso_images, :iso_datastore
      drop_table :iso_datastores
    end
  end

  def down
    say_with_time("Create IsoDatastore table") do
      create_table :iso_datastores, :force => :cascade do |t|
        t.bigint :ems_id
        t.datetime :last_refresh_on
      end

      add_reference :iso_images, :iso_datastore
    end
  end
end
