class UpdatePolicyRsopStartpageUrl < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating start page url for users who had Policy Simulation set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy/rsop'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy_rsop'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page url for users who had Policy Simulation pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy_rsop'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy/rsop'}))
        end
      end
    end
  end
end
