class AddTypeColumnToServiceOrder < ActiveRecord::Migration[5.0]
  class ServiceOrder < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled # disable STI
  end
  class MiqRequest < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    add_column :service_orders, :type, :string

    say_with_time("Set service_orders type") do
      v2v_order_ids = MiqRequest.in_my_region.where(:type => 'ServiceTemplateTransformationPlanRequest').pluck(:service_order_id)
      ServiceOrder.where(:id => v2v_order_ids).update_all(:type => 'ServiceOrderV2V')

      ServiceOrder.in_my_region.where(:type => nil).update_all(:type => 'ServiceOrderCart')
    end
  end

  def down
    remove_column :service_orders, :type
  end
end
