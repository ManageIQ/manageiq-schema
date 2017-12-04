class MiqGroupSettingsToHashWithIndifferentAccess < ActiveRecord::Migration[5.0]
  class MiqGroup < ActiveRecord::Base
    serialize :settings
  end

  def up
    say_with_time("Migrate all MiqGroup Settings to HashWithIndifferentAccess") do
      MiqGroup.all.each do |group|
        group.update_attributes(:settings => group.settings.with_indifferent_access) if group.settings
      end
    end
  end
end
