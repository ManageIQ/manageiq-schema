class AddPriceToServiceTemplates < ActiveRecord::Migration[5.0]
  def change
    add_reference :service_templates, :currency, :type => :bigint
    add_column :service_templates, :price, :float
  end
end
