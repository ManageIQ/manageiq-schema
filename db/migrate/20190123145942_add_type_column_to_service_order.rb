class AddTypeColumnToServiceOrder < ActiveRecord::Migration[5.0]
  def up
    add_column :service_order, :type, :string

    say_with_time("Set service_order type") do
      ServiceOrder.all.each do |service_order|
        type = service_order.miq_requests.pluck(:type).any? { |t| t === 'ServiceTemplateTransformationPlanRequest' } ? ServiceOrderV2V : ServiceOrderCart
        service_order.update_attribute(:type, type)
      end
    end
  end

  def down
    remove_column :service_order, :type
  end
end
