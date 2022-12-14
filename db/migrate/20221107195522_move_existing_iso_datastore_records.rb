class MoveExistingIsoDatastoreRecords < ActiveRecord::Migration[6.1]
  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    has_many :iso_datastores, :foreign_key => :ems_id, :class_name => "MoveExistingIsoDatastoreRecords::IsoDatastore"
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "MoveExistingIsoDatastoreRecords::ExtManagementSystem"
    has_many :iso_images, :class_name => "MoveExistingIsoDatastoreRecords::IsoImage"
  end

  class IsoDatastore < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :ext_management_system, :foreign_key => :ems_id, :class_name => "MoveExistingIsoDatastoreRecords::ExtManagementSystem"
    has_many :iso_images, :class_name => "MoveExistingIsoDatastoreRecords::IsoImage"
  end

  class IsoImage < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :storage, :class_name => "MoveExistingIsoDatastoreRecords::Storage"
    belongs_to :iso_datastore, :class_name => "MoveExistingIsoDatastoreRecords::IsoDatastore"
  end

  def up
    say_with_time("Transfer existing IsoDatastore records to Storage") do
      add_reference :iso_images, :storage

      IsoDatastore.in_my_region
                  .joins(:ext_management_system)
                  .where(:ext_management_systems => {:type => ["ManageIQ::Providers::Ovirt::InfraManager", "ManageIQ::Providers::Redhat::InfraManager"]})
                  .each do |datastore|
        datastore_class_name = "#{datastore.ext_management_system.type}::IsoDatastore"
        storage = Storage.create!(:ems_id => datastore.ems_id, :store_type => "ISO", :type => datastore_class_name)

        datastore.iso_images.each do |image|
          image.update!(:storage_id => storage.id)
        end
      end
    end
  end

  def down
    say_with_time("Transfer eligible Storage records to IsoDatastore") do
      Storage.in_my_region
             .where(:type => ["ManageIQ::Providers::Ovirt::InfraManager::IsoDatastore", "ManageIQ::Providers::Ovirt::InfraManager::IsoDatastore"])
             .each do |storage|
        datastore = IsoDatastore.create!(:ems_id => storage.ems_id)

        storage.iso_images.each do |image|
          image.update!(:iso_datastore_id => datastore.id)
        end

        storage.destroy!
      end

      remove_reference :iso_images, :storage
    end
  end
end
