class RemoveCentralAdminRegionAuthRecords < ActiveRecord::Migration[5.0]
  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    Authentication.where(:resource_type => 'MiqRegion').delete_all
  end
end
