class DropCockpitRole < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base; end

  def up
    say_with_time("Deleting cockpit role configuration") do
      SettingsChange.where("key = '/server/role' AND value LIKE '%ws_cockpit%'").select('id', 'value').each do |row|
        if row.value == 'ws_cockpit'
          row.delete
        else
          row.update(:value => row.value.split(',').tap { |a| a.delete("ws_cockpit") }.join(','))
        end
      end
    end
  end
end
