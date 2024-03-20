class AddGuidToMiqEnterprise < ActiveRecord::Migration[6.1]
  class MiqEnterprise < ActiveRecord::Base; end

  def up
    say_with_time("Creating guids for MiqEnterprise objects") do
      add_column :miq_enterprises, :guid, :string

      MiqEnterprise.all.each { |miq_enterprise| miq_enterprise.update!(:guid => SecureRandom.uuid) }
    end
  end

  def down
    say_with_time("Removing guids from MiqEnterprise objects") do
      remove_column :miq_enterprises, :guid
    end
  end
end
