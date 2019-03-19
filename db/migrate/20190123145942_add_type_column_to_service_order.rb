class AddTypeColumnToServiceOrder < ActiveRecord::Migration[5.0]
  def up
    add_column :service_order, :request_type, :string

    say_with_time("Set service_order request_type") do
      ServiceOrder.all.each do |service_order|
        request_type = service_order.miq_requests.pluck(:type).uniq.sort.join(',')
        service_order.update_attribute(:request_type, request_type)
      end
    end
  end

  def down
    remove_column :service_order, :request_type
  end
end
