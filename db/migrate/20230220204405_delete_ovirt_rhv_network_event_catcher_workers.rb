class DeleteOvirtRhvNetworkEventCatcherWorkers < ActiveRecord::Migration[6.1]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Deleting Ovirt/RHV Network Event Catcher Workers") do
      MiqWorker.where(
        :type => %w[
          ManageIQ::Providers::Ovirt::NetworkManager::EventCatcher
          ManageIQ::Providers::Redhat::NetworkManager::EventCatcher
        ]
      ).delete_all
    end
  end
end
