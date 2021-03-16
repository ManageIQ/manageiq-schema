class UpdateAutomationProviderStartpage < ActiveRecord::Migration[6.0]
  class User < ActiveRecord::Base
    serialize :settings, Hash
  end

  def up
    say_with_time 'Updating start page for users who had Ansible Tower explorer set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'automation_manager/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'ems_automation/show_list'}))
        end
      end
    end
  end

  def down
    say_with_time 'Reverting start page for users who had non-explorer Ansible Tower pages set' do
      User.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'ems_automation/show_list'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'automation_manager/explorer'}))
        end
      end
    end
  end
end
