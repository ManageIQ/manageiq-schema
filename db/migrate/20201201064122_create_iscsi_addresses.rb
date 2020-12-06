class CreateIscsiAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :iscsi_addresses do |t|
      t.string :iqn
      t.string :chap_name
      t.string :chap_secret
    end
  end
end
