class UpdateConditionsStartpageUrlAfterDeExplorization < ActiveRecord::Migration[6.0]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating start page for users who had Policy Conditions explorer set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'condition/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'condition/show_list'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page for users who had non-explorer Policy Conditions pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'condition/show_list'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'condition/explorer'}))
        end
      end
    end
  end
end
