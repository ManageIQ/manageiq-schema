class UpdatePolicyExportStartpageUrl < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Update start page url path for users who had Policy Import/Export set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy/export'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy_export'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page url path for users who had Policy Import/Export pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'miq_policy_export'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'miq_policy/export'}))
        end
      end
    end
  end
end
