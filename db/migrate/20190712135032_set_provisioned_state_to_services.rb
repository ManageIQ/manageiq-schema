class SetProvisionedStateToServices < ActiveRecord::Migration[5.1]
  class Service < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Update service lifecycle state values") do
      Service.in_my_region.where(:lifecycle_state => nil, :retired => nil).update_all(:lifecycle_state => 'provisioned')
    end
  end
end
