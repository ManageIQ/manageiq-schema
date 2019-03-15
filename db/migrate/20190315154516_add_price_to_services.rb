class AddPriceToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :price, :bigint
    add_column :services, :currency, :string
  end
end
