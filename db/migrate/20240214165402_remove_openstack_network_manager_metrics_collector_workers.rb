class RemoveOpenstackNetworkManagerMetricsCollectorWorkers < ActiveRecord::Migration[6.1]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Deleting all Openstack NetworkManager MetricsCollectorWorker records") do
      MiqWorker.where(:type => "ManageIQ::Providers::Openstack::NetworkManager::MetricsCollectorWorker").delete_all
    end
  end
end
