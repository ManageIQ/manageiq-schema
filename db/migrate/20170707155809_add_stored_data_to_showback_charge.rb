class AddStoredDataToShowbackCharge < ActiveRecord::Migration[5.0]
  def change
    add_column :showback_charges, :stored_data, :jsonb, :comment => 'Snapshot of the data of showbackevent'
  end
end
