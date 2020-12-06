class CreateFiberChannelAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :fiber_channel_addresses do |t|
      t.string :chap_name
      t.string :chap_secret
      t.string :wwpn
    end
  end
end