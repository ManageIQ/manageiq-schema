class AdjustControlExplorerStartpageEntries < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating starting page for users who had control explorer set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'control/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy_set/explorer'}))
        end
      end
    end
  end

  def down
    say_with_time 'Updating starting page for users who had miq_policy_set back to unified control explorer' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy_set/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'control/explorer'}))
        end
      end
    end
  end
end
