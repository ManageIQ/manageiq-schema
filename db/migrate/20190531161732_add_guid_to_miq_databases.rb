class AddGuidToMiqDatabases < ActiveRecord::Migration[5.0]
  class MiqDatabase < ActiveRecord::Base
  end

  def up
    add_column :miq_databases, :guid, :string, :limit => 36

    say_with_time("Create default guids for miq_databases") do
      MiqDatabase.all.each { |d| d.update!(:guid => SecureRandom.uuid) }
    end
  end

  def down
    remove_column :miq_databases, :guid
  end
end
