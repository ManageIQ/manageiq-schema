class RenameWebsocketToRemoteConsole < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base; end

  class ServerRole < ActiveRecord::Base; end

  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    rename_column :miq_servers, :has_active_websocket, :has_active_remote_console

    say_with_time("Renaming the websocket server role to remote_console") do
      ServerRole.where(:name => 'websocket').update(:name => 'remote_console', :description => "Remote Consoles")
    end

    say_with_time("Renaming the /log/level_websocket key to /log/level_remote_console in SettingsChange") do
      SettingsChange.where(:key => '/log/level_websocket').update(:key => '/log/level_remote_console')
    end

    say_with_time("Renaming all websocket_worker related SettingsChange keys to remote_console_worker") do
      SettingsChange.where("key LIKE '/workers/worker_base/websocket_worker/%'").select('id, key').each do |row|
        row.update(:key => row.key.sub('websocket_worker', 'remote_console_worker'))
      end
    end

    say_with_time("Renaming all websocket server role SettingsChange records to remote_console") do
      SettingsChange.where("key = '/server/role' AND value LIKE '%websocket%'").select('id', 'value').each do |row|
        row.update(:value => row.value.sub('websocket', 'remote_console'))
      end
    end

    say_with_time("Removing all MiqWorker records related to WebsocketWorker instances") do
      MiqWorker.where(:type => 'MiqWebsocketWorker').delete_all
    end
  end

  def down
    rename_column :miq_servers, :has_active_remote_console, :has_active_websocket

    say_with_time("Renaming the remote_console server role to websocket") do
      ServerRole.where(:name => 'remote_console').update(:name => 'websocket', :description => "Websocket")
    end

    say_with_time("Renaming the /log/level_remote_console key to /log/level_websocket in SettingsChange") do
      SettingsChange.where(:key => '/log/level_remote_console').update(:key => '/log/level_websocket')
    end

    say_with_time("Renaming all remote_console_worker related SettingsChange keys to websocket_worker") do
      SettingsChange.where("key LIKE '/workers/worker_base/remote_console_worker/%'").select('id, key').each do |row|
        row.update(:key => row.key.sub('remote_console_worker', 'websocket_worker'))
      end
    end

    say_with_time("Renaming all remote_console server role SettingsChange records to websocket") do
      SettingsChange.where("key = '/server/role' AND value LIKE '%remote_console%'").select('id', 'value').each do |row|
        row.update(:value => row.value.sub('remote_console', 'websocket'))
      end
    end
  end
end
