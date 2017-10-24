class AddOptionsToMiqAeMethod < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_ae_methods, :options, :text
  end
end
