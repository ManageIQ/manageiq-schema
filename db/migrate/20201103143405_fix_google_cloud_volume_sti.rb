class FixGoogleCloudVolumeSti < ActiveRecord::Migration[5.2]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudVolume < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system,
               :foreign_key => :ems_id,
               :class_name  => "FixGoogleCloudVolumeSti::ExtManagementSystem"
  end

  GOOGLE_CLOUD_KLASS        = "ManageIQ::Providers::Google::CloudManager".freeze
  GOOGLE_CLOUD_VOLUME_KLASS = "ManageIQ::Providers::Google::CloudManager::CloudVolume".freeze

  def up
    say_with_time("Fix GCE CloudVolumes STI Class") do
      gce_relation = ExtManagementSystem.in_my_region.where(:type => GOOGLE_CLOUD_KLASS)
      CloudVolume.in_my_region.where(:type => nil, :ext_management_system => gce_relation)
                 .update_all(:type => GOOGLE_CLOUD_VOLUME_KLASS)
    end
  end

  def down
    say_with_time("Fix GCE CloudVolumes STI Class") do
      gce_relation = ExtManagementSystem.in_my_region.where(:type => GOOGLE_CLOUD_KLASS)
      CloudVolume.in_my_region.where(:type => GOOGLE_CLOUD_VOLUME_KLASS, :ext_management_system => gce_relation)
                 .update_all(:type => nil)
    end
  end
end
