class UpdateAlertProfilesStartpageUrlAfterDeExplorization < ActiveRecord::Migration[6.0]
  class User < ActiveRecord::Base
    serialize :settings, :type => Hash
  end

  def up
    say_with_time 'Updating start page for users who had Alert Profile explorer set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_alert_set/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_alert_set/show_list'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page for users who had non-explorer Alert Profile pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_alert_set/show_list'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_alert_set/explorer'}))
        end
      end
    end
  end
end
