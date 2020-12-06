class CreateFiberChannelAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :fiber_channel_addresses do |t|
      t.string :wwpn
      t.string :wwnn
    end
  end
end
