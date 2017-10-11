class MoveOpenstackRefresherSettings < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time('Move Openstack provider refresher settings') do
      SettingsChange.where(:key => '/ems/ems_openstack/refresh/inventory_object_refresh').update(:key => '/ems/ems_refresh/openstack/inventory_object_refresh')
      SettingsChange.where(:key => '/ems/ems_openstack/refresh/heat/is_global_admin').update(:key => '/ems/ems_refresh/openstack/heat/is_global_admin')
      SettingsChange.where(:key => '/ems/ems_openstack/refresh/is_admin').update(:key => '/ems/ems_refresh/openstack/is_admin')
      SettingsChange.where(:key => '/ems/ems_openstack/refresh/event_targeted_refresh').update(:key => '/ems/ems_refresh/openstack/allow_targeted_refresh')
    end
  end
end
