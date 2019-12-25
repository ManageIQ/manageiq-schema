require_migration

describe SplitDiskTypeToThinAndFormatForDisk do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:storage_stub) { migration_stub(:Storage) }
  let(:disk_stub) { migration_stub(:Disk) }

  HASH_UP = {
  'Redhat::InfraManager'    => {:thin  => {:thin => true, :format => nil},
                                  :thick => {:thin => false, :format => nil}},
  'Vmware::InfraManager'    => {:thin             => {:thin => true, :format => 'vmdk'},
                                :thick            => {:thin => false, :format => 'vmdk'},
                                :any_other_format => {:thin => false, :format => 'any_other_format'}},
  'Vmware::CloudManager'    => {:any_other_format => {:thin => true, :format => 'any_other_format'}},
  'Microsoft::InfraManager' => {:thin             => {:thin => true, :format => 'vhdx'},
                                :thick            => {:thin => false, :format => 'vhdx'},
                                :unknown          => {:thin => false, :format => 'unknown'}},
  'Azure::CloudManager'     => {:any_format => {:thin => true, :format => 'any_format'}},
  'Openstack::InfraManager' => {nil => {:thin => nil, :format => nil}}
  }.freeze

  def device_name(vendor, type)
    "#{vendor}_#{type}"
  end

  def type_from_thin_and_format(thin_and_format_hash)
    "#{thin_and_format_hash[:thin]}_#{thin_and_format_hash[:format]}"
  end

  migration_context :up do
    HASH_UP.each do |vendor, configurations|
      it "properly sets the disks format and thin values based on its disk_type for all vendors" do
        ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}")
        storage = storage_stub.create!(:ems_id => ems.id)
        configurations.each do |disk_type, _new_column_values|
          disk_stub.create!(:storage_id => storage.id, :disk_type => disk_type, :device_name => device_name(vendor, disk_type))
        end

        migrate
        aggregate_failures "up migration" do
          configurations.each do |disk_type, expected_new_column_values|
            disk = disk_stub.where(:device_name => device_name(vendor, disk_type) ).first
            expect(disk.thin).to eq(expected_new_column_values[:thin]), "properly migrates a disk with disk_type #{disk_type} for provider #{vendor}"
            expect(disk.format).to eq(expected_new_column_values[:format]), "properly migrates a disk with disk_type #{disk_type} for provider #{vendor}"
          end
        end
      end
    end
  end

  HASH_DOWN = {
    'Redhat::InfraManager'    => { { thin: true, format: 'anything' } => "thin" ,
                                   { thin: false, format: 'anything' } => "thick"},
  'Vmware::InfraManager'    => {{ thin: true, format: 'vmdk' } => "thin",
                                { thin: false, format: 'vmdk' } => "thick",
                                { thin: true, format: 'any_other_format' } => 'any_other_format',
                                { thin: false, format: 'any_other_format' } => 'any_other_format'},
  'Vmware::CloudManager'    => {{:thin => true, :format => 'any_other_format'} => 'any_other_format',
                                {:thin => false, :format => 'any_other_format'} => 'any_other_format'},
  'Microsoft::InfraManager' => {{:thin => true, :format => 'vhdx'} => "thin",
                                {:thin => false, :format => 'vhdx'} => "thick",
                                {:thin => false, :format => 'unknown'} => "unknown"},
  'Azure::CloudManager'     => {{:thin => true, :format => 'any_format'} => "any_format",
                                {:thin => false, :format => 'any_format'} => "any_format"},
  'Openstack::InfraManager' => {{:thin => nil, :format => nil} => nil}
  }.freeze

  migration_context :down do
    HASH_DOWN.each do |vendor, configurations|
      it "properly sets the disk_type value for a disk based on thin and format value for all providers" do
        ems = ext_management_system_stub.create!(:type => "ManageIQ::Providers::#{vendor}")
        storage = storage_stub.create!(:ems_id => ems.id)
        configurations.each do |thin_and_format, _disk_type|
          disk_stub.create!(:storage_id => storage.id, :thin => thin_and_format[:thin],
                            :format => thin_and_format[:format],
                            :device_name => device_name(vendor, type_from_thin_and_format(thin_and_format)))
        end

        migrate

        aggregate_failures "down migration" do
          configurations.each do |thin_and_format, disk_type|
            disk = disk_stub.where(:device_name => device_name(vendor,
                                                               type_from_thin_and_format(thin_and_format))).first
            expect(disk.disk_type).to eq(disk_type), "properly migrates a disk with thin: #{thin_and_format[:thin]} format: #{thin_and_format[:format]} for provider #{vendor}"
          end
        end
      end
    end
  end
end
