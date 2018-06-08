class UpdateVmwareFolderTypes < ActiveRecord::Migration[5.0]
  VMWARE_FOLDER = "ManageIQ::Providers::Vmware::InfraManager::Folder".freeze
  VMWARE_DC = "ManageIQ::Providers::Vmware::InfraManager::Datacenter".freeze

  class EmsFolder < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  class Datacenter < EmsFolder
    self.inheritance_column = :_type_disabled # disable STI
  end

  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Setting VMware folder types") do
      EmsFolder.joins('join ext_management_systems on ems_folders.ems_id = ext_management_systems.id')
               .where(:type => nil, :ext_management_systems => {:type => "ManageIQ::Providers::Vmware::InfraManager"})
               .update_all(:type => VMWARE_FOLDER)

      EmsFolder.joins('join ext_management_systems on ems_folders.ems_id = ext_management_systems.id')
               .where(:type => 'Datacenter', :ext_management_systems => {:type => "ManageIQ::Providers::Vmware::InfraManager"})
               .update_all(:type => VMWARE_DC)
    end
  end

  def down
    say_with_time("Clearing all VMware folder types") do
      EmsFolder.where(:type => VMWARE_FOLDER).update_all(:type => nil)
      EmsFolder.where(:type => VMWARE_DC).update_all(:type => 'Datacenter')
    end
  end
end
