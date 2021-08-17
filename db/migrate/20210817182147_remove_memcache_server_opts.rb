class RemoveMemcacheServerOpts < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Remove memcache_server_opts settings") do
      SettingsChange.in_my_region.where(:key => "/session/memcache_server_opts").delete_all
    end
  end
end
