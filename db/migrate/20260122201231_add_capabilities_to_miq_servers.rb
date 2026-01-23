class AddCapabilitiesToMiqServers < ActiveRecord::Migration[7.2]
  def change
    add_column :miq_servers, :capabilities, :jsonb, :default => {}
  end
end
