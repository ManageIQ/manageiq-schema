class CreateSanAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :san_addresses do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      t.belongs_to :owner, :polymorphic => true, :type => :bigint
      t.string :iqn
      t.string :chap_name
      t.string :chap_secret
      t.string :wwpn
      t.string :wwnn
      t.string :type

      t.timestamps
    end
  end
end
