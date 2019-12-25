class SplitDiskTypeToThinAndFormatForDisk < ActiveRecord::Migration[5.1]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    belongs_to :ext_management_system, foreign_key: "ems_id"
  end

  class Disk < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    belongs_to :storage
    has_one :ext_management_system, through: :storage
  end

  HASH_UP = {
    'Redhat::InfraManager' => [ { disk_type_query: "disk_type = 'thin'", thin_value: true, format_value: "NULL" }, { disk_type_query: "disk_type = 'thick'", thin_value: false, format_value: "NULL"}],
    'Vmware::InfraManager' => [ { disk_type_query: "disk_type = 'thin'", thin_value: true, format_value: "'vmdk'" }, { disk_type_query: "disk_type = 'thick'", thin_value: false, format_value: "'vmdk'"},
                  { disk_type_query: "disk_type NOT IN ('thick', 'thin')", thin_value: false, format_value: "disk_type"}],
    'Vmware::CloudManager' => [ { disk_type_query: "true", thin_value: true, format_value: "disk_type" } ],
    'Microsoft::InfraManager' => [ { disk_type_query: "disk_type = 'thin'", thin_value: true, format_value: "'vhdx'" }, { disk_type_query: "disk_type = 'thick'", thin_value: false, format_value: "'vhdx'"},
                  { disk_type_query: "disk_type NOT IN ('thick', 'thin')", thin_value: false, format_value: "'unknown'"}],
    'Azure::CloudManager' => [ { disk_type_query: "true", thin_value: true, format_value: "disk_type" } ]
  }

  def up
    add_column :disks, :format, :string
    add_column :disks, :thin, :boolean
    HASH_UP.each do |provider, queries|
      queries.each do |query_opts|
        Disk.in_my_region.joins(:storage).joins(:ext_management_system).where(:ext_management_systems => {type: "ManageIQ::Providers::#{provider}"})
          .where(query_opts[:disk_type_query]).update_all("thin = #{query_opts[:thin_value]}, format = #{query_opts[:format_value]}")
      end
    end
    remove_column :disks, :disk_type
  end

    HASH_DOWN = {
    'Redhat::InfraManager' => [ { thin_and_format_query: "true", disk_type_value: "(CASE thin WHEN true THEN 'thin' ELSE 'thick' END)" }],
    'Vmware::InfraManager' => [ { thin_and_format_query: "format = 'vmdk'", disk_type_value: "(CASE thin WHEN true THEN 'thin' ELSE 'thick' END)" },
                                { thin_and_format_query: "format != 'vmdk'", disk_type_value: "format"}],
    'Vmware::CloudManager' => [ {thin_and_format_query: "true", disk_type_value: "format"}],
    'Microsoft::InfraManager' => [ { thin_and_format_query: "format = 'vhdx'", disk_type_value: "(CASE thin WHEN true THEN 'thin' ELSE 'thick' END)" },
                                   { thin_and_format_query: "format != 'vhdx'", disk_type_value: "format"}],
    'Azure::CloudManager' => [ {thin_and_format_query: "true", disk_type_value: "format"}],
    }

  def down
    add_column :disks, :disk_type, :string
    HASH_DOWN.each do |provider, queries|
      queries.each do |query_opts|
        Disk.in_my_region.joins(:storage).joins(:ext_management_system).where(:ext_management_systems => {type: "ManageIQ::Providers::#{provider}"})
          .where(query_opts[:thin_and_format_query]).update_all("disk_type = #{query_opts[:disk_type_value]}")
      end
    end
    remove_column :disks, :format
    remove_column :disks, :thin
  end
end
