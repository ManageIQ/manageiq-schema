class UpdateStartpageShortcutAfterActionsDeExplorization < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating start page for users who had Actions explorer set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_action/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_action/show_list'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page for users who had non-explorer Actions pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_action/show_list'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_action/explorer'}))
        end
      end
    end
  end
end