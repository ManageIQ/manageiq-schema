class AddEmsIdToStorages < ActiveRecord::Migration[5.0]
  def change
    add_reference :storages, :ems, :type => :bigint, :index => true, :references => :ext_management_system
  end
end
