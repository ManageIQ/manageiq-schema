class SetTypeOnSnapshots < ActiveRecord::Migration[6.1]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    has_many :vms_and_templates, :foreign_key => :ems_id, :class_name => "SetTypeOnSnapshots::VmOrTemplate"
    has_many :snapshots, :through => :vms_and_templates, :class_name => "SetTypeOnSnapshots::Snapshot"
  end

  class Snapshot < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :vm_or_template, :class_name => "SetTypeOnSnapshots::VmOrTemplate"
    has_one :ext_management_system, :through => :vm_or_template, :class_name => "SetTypeOnSnapshots::ExtManagementSystem"
  end

  class VmOrTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
    self.table_name         = :vms

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "SetTypeOnSnapshots::ExtManagementSystem"
    has_many :snapshots, :class_name => "SetTypeOnSnapshots::Snapshot"
  end

  def up
    say_with_time("Setting Snasphot type") do
      [
        'IbmCloud::PowerVirtualServers::CloudManager',
        'IbmCic::CloudManager',
        'IbmPowerVc::CloudManager',
        'Openstack::CloudManager',
        'Microsoft::InfraManager',
        'Ovirt::InfraManager',
        'Redhat::InfraManager',
        'Vmware::InfraManager',
      ].each do |provider|
        ems_class_name      = "ManageIQ::Providers::#{provider}"
        snapshot_class_name = "#{ems_class_name}::Snapshot"

        Snapshot.in_my_region
                .joins(:ext_management_system)
                .where(:ext_management_systems => {:type => ems_class_name})
                .update_all(:type => snapshot_class_name)
      end
    end
  end

  def down
    say_with_time("Resetting Snapshot type") do
      Snapshot.in_my_region.update_all(:type => nil)
    end
  end
end
