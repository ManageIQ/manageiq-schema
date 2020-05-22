class UpdateChargebackAssignmentsStartpage < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
    serialize :settings, Hash
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time 'Updating starting page for users who had chargeback assignments set' do
      User.in_my_region.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'chargeback_assignments/explorer'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'chargeback_assignment'}))
        end
      end
    end
  end

  def down
    say_with_time 'Updating starting page for users who had non-explorer chargeback assignments pages set' do
      User.in_my_region.select(:id, :settings).each do |user|
        if user.settings&.dig(:display, :startpage) == 'chargeback_assignment'
          user.update!(:settings => user.settings.deep_merge(:display => {:startpage => 'chargeback_assignments/explorer'}))
        end
      end
    end
  end
end
