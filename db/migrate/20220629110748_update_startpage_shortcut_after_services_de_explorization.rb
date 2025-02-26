class UpdateStartpageShortcutAfterServicesDeExplorization < ActiveRecord::Migration[6.0]
  class User < ActiveRecord::Base
    serialize :settings, :type => Hash
  end

  def up
    say_with_time('Updating start page for users who had Services explorer set') do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'service/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'service/show_list'}))
        end
      end
    end
  end

  def down
    say_with_time('Reverting start page for users who had non-explorer Service pages set') do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'service/show_list'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'service/explorer'}))
        end
      end
    end
  end
end
