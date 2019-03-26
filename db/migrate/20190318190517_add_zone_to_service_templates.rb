class AddZoneToServiceTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :service_templates, :zone_id, :bigint
  end
end
