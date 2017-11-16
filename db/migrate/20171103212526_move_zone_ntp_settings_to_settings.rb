class MoveZoneNtpSettingsToSettings < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
    serialize :value
  end
  class Zone < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time("Moving Zone NTP settings from Zone#settings[:ntp] to Settings") do
      Zone.all.each do |zone|
        servers = (zone.settings.delete(:ntp) || {})[:server]
        next if servers.blank?
        SettingsChange.create!(:resource_type => "Zone", :resource_id => zone.id, :key => "/ntp/server", :value => servers)
        zone.save
      end
    end
  end

  def down
    say_with_time("Moving Zone NTP settings from Settings to Zone#settings[:ntp]") do
      Zone.all.each do |zone|
        setting = SettingsChange.find_by(:resource_type => "Zone", :resource_id => zone.id, :key => "/ntp/server").try(:destroy)
        servers = setting.try(:value)
        next if servers.blank?
        zone.settings.store_path(:ntp, :server, servers)
        zone.save
      end
    end
  end
end
