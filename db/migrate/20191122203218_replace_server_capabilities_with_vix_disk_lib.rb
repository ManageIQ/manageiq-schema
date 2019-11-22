class ReplaceServerCapabilitiesWithVixDiskLib < ActiveRecord::Migration[5.1]
  class MiqServer < ActiveRecord::Base
    serialize :capabilities
    include ActiveRecord::IdRegions
  end

  def up
    add_column :miq_servers, :has_vix_disk_lib, :boolean

    MiqServer.in_my_region.each do |miq_server|
      miq_server.update(
        :has_vix_disk_lib => miq_server.capabilities.try(:[], :vixDisk) || false
      )
    end

    remove_column :miq_servers, :capabilities
  end

  def down
    add_column :miq_servers, :capabilities, :text

    MiqServer.in_my_region.each do |miq_server|
      miq_server.update(
        :capabilities => { :vixDisk => miq_server.has_vix_disk_lib || false }
      )
    end

    remove_column :miq_servers, :has_vix_disk_lib
  end
end
