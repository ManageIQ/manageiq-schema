class MoveEmsRefreshOpenstackSettings < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time('Move ems_refresh Openstack provider refresher settings under the root') do
      SettingsChange.where('key LIKE ?', '/ems/ems_refresh/openstack%').each do |s|
        s.key = s.key.sub('/ems/ems_refresh', '/ems_refresh')
        s.save!
      end
    end
  end
end
