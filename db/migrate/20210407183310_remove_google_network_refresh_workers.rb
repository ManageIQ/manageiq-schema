class RemoveGoogleNetworkRefreshWorkers < ActiveRecord::Migration[6.0]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    MiqWorker.where(:type => "ManageIQ::Providers::Google::NetworkManager::RefreshWorker").delete_all
  end
end
