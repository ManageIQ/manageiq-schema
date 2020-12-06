class CreateIscsiAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :iscsi_addresses do |t|
      t.string :iqn
    end
  end
end