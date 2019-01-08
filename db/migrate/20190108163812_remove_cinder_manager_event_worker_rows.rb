class RemoveCinderManagerEventWorkerRows < ActiveRecord::Migration[5.0]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    # ManageIQ::Providers::StorageManager::CinderManager::EventCatcher was removed in 772bdc283360e99f9cf2209184297d1827f3a9e6
    # https://github.com/ManageIQ/manageiq/pull/14962
    MiqWorker.where(:type => "ManageIQ::Providers::StorageManager::CinderManager::EventCatcher").delete_all
  end
end
