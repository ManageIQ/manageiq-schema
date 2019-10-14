class RemoveQuadiconSettings < ActiveRecord::Migration[5.0]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time("Dropping quadicon settings keys from user settings") do
      User.where("settings like '%quadicons%'").each do |user|
        settings = user.settings

        next unless settings[:quadicons]

        settings.delete(:quadicons)
        user.update!(:settings => settings)
      end
    end
  end
end
