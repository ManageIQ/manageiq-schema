class AddCapabilitiesToProvider < ActiveRecord::Migration[6.0]
  def change
    add_column :providers, :capabilities, :jsonb, :default => {}
  end
end
