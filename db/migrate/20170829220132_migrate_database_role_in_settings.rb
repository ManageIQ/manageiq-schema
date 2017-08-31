class MigrateDatabaseRoleInSettings < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time("Convert old 'database' role to 'database_operations'") do
      SettingsChange.where(:key => "/server/role").each do |s|
        s.value.gsub!(/\bdatabase\b/, 'database_operations')
        s.save!
      end
    end
  end

  # No down migration, because there was a runtime migration at server
  # startup that would have corrected this anyway.
end
