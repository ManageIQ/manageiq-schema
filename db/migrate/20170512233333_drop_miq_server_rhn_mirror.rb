class DropMiqServerRhnMirror < ActiveRecord::Migration[5.0]
  class ServerRole < ActiveRecord::Base; end
  class AssignedServerRole < ActiveRecord::Base; end
  class SettingsChange < ActiveRecord::Base
    serialize :value
  end

  def up
    remove_column :miq_servers, :rhn_mirror

    say_with_time("Removing RHN Mirror role") do
      role = ServerRole.find_by(:name => "rhn_mirror")
      if role
        AssignedServerRole.where(:server_role_id => role.id).delete_all
        role.delete
      end
    end

    say_with_time("Removing RHN Mirror role from currently configured servers") do
      changes = SettingsChange.where(:key => "/server/role")
      changes.each do |change|
        role_list = change.value.split(",")
        change.value = role_list.reject { |role| role == "rhn_mirror" }.join(",")
        change.save!
      end
    end

    if Rails.env.production? && File.exist?('/var/www/miq/vmdb')
      say_with_time("Removing files created by RHN Mirror role") do
        require 'fileutils'
        require 'linux_admin'

        if File.exist?("/etc/fstab")
          LinuxAdmin::FSTab.instance.entries.delete_if { |e| e.mount_point == "/repo" }
          LinuxAdmin::FSTab.instance.write!
        end

        FileUtils.rm_f("/etc/httpd/conf.d/manageiq-https-mirror.conf")
        FileUtils.rm_f("/etc/yum.repos.d/manageiq-mirror.repo")
        FileUtils.rm_rf(Dir.glob("/repo/*"))
      end
    end
  end

  def down
    add_column :miq_servers, :rhn_mirror, :boolean
  end
end
