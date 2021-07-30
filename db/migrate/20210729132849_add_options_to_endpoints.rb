class AddOptionsToEndpoints < ActiveRecord::Migration[6.0]
  def change
    add_column :endpoints, :options, :jsonb, :default => {}
  end
end
