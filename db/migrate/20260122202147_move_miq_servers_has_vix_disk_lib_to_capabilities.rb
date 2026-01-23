class MoveMiqServersHasVixDiskLibToCapabilities < ActiveRecord::Migration[7.2]
  class MiqServer < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Setting MiqServer capabilities.vix_disk_lib") do
      MiqServer
        .in_my_region
        .update_all("capabilities = jsonb_set(capabilities, '{vix_disk_lib}', to_json(has_vix_disk_lib)::jsonb)")
    end
  end

  def down
    say_with_time("Setting MiqServer has_vix_disk_lib") do
      MiqServer.in_my_region.each do |miq_server|
        miq_server.has_vix_disk_lib = miq_server.capabilities["vix_disk_lib"]
        miq_server.save!
      end
    end
  end
end
