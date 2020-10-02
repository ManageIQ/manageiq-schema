class DeleteWorkersWithJsonQueueNames < ActiveRecord::Migration[5.2]
  class MiqWorker < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    MiqWorker.in_my_region.where("queue_name LIKE ?", "\[%\]").delete_all
  end
end
