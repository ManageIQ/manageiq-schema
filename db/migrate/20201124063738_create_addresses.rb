class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.references :physical_storage, :type => :bigint, :index => true
      t.string :chap_name
      t.string :chap_secret
      t.string :iqn
      t.string :wwpn
      t.string :port_type
      t.references :physical_storage_consumer, :type => :bigint, :index => true
    end
  end
end