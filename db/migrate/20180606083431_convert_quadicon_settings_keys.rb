class ConvertQuadiconSettingsKeys < ActiveRecord::Migration[5.0]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time("Converting :ems quadicon settings keys for users to :ems_infra") do
      User.all.each do |user|
        settings = user.settings
        next unless settings[:quadicons]
        settings[:quadicons][:ems_infra] = settings[:quadicons].delete(:ems)
        user.update_attributes(:settings => settings)
      end
    end
  end

  def down
    say_with_time("Converting :ems_infra quadicon settings keys for users to :ems") do
      User.all.each do |user|
        settings = user.settings
        next unless settings[:quadicons]
        settings[:quadicons][:ems] = settings[:quadicons].delete(:ems_infra)
        user.update_attributes(:settings => settings)
      end
    end
  end
end
