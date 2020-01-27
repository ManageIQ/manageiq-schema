class RemoveMiqVimBrokerWorkerRows < ActiveRecord::Migration[5.1]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    MiqWorker.where(:type => "MiqVimBrokerWorker").delete_all
  end
end
