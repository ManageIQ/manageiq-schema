class SetZoneVisibleColumnDefaultTrue < ActiveRecord::Migration[5.0]
  class Zone < ActiveRecord::Base
  end

  def change
    change_column_default(:zones, :visible, :from => nil, :to => true)
    Zone.where(:visible => nil).update_all(:visible => true)
  end
end
