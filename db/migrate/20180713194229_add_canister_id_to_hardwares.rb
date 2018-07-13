class AddCanisterIdToHardwares < ActiveRecord::Migration[5.0]
  def change
    add_column :hardwares, :canister_id, :bigint
  end
end
