class UpdatePolicyLogStartpageUrl < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating start page url for users who had Policy Log set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy/log'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy_log'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page url for users who had Policy Log pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy_log'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy/log'}))
        end
      end
    end
  end
end
