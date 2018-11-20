class SetVmConnectionState < ActiveRecord::Migration[4.2]
  class VmOrTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
  end

  def up
    say_with_time('Filling nil connection_state to "connected"') do
      VmOrTemplate.in_my_region.where(:connection_state => nil).update_all(:connection_state => 'connected')
    end
  end
end
