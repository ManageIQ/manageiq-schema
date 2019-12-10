class SubclassStorages < ActiveRecord::Migration[5.1]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SubclassStorages::ExtManagementSystem"
  end

  def up
    [
      'Microsoft',
      'Redhat',
      'Vmware',
    ].each do |provider|
      ems_class_name = "ManageIQ::Providers::#{provider}::InfraManager"
      storage_class_name = "#{ems_class_name}::Storage"
      Storage.in_my_region
             .joins(:ext_management_system)
             .where(:ext_management_systems => {:type => ems_class_name})
             .update_all(:type => storage_class_name)
    end
  end

  def down
    Storage.in_my_region.update_all(:type => nil)
  end
end
