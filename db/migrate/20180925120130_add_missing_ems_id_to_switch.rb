class AddMissingEmsIdToSwitch < ActiveRecord::Migration[5.0]
  def up
    say_with_time("Add missing ems_id to switch") do
      connection.execute <<-SQL
        UPDATE switches
          SET ems_id=hosts.ems_id
          FROM host_switches
          INNER JOIN hosts ON hosts.id = host_switches.host_id
          WHERE host_switches.switch_id = switches.id
             AND hosts.ems_id IS NOT NULL
             AND switches.shared IS true
      SQL

      connection.execute <<-SQL
        UPDATE switches
          SET host_id=hosts.id
          FROM host_switches
          INNER JOIN hosts ON hosts.id = host_switches.host_id
          WHERE host_switches.switch_id = switches.id
             AND switches.ems_id IS NULL
             AND switches.shared IS NOT true
      SQL
    end
  end
end
