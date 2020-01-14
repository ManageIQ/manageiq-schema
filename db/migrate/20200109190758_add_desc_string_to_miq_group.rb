class AddDescStringToMiqGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :miq_groups, :detailed_description, :string
  end
end
