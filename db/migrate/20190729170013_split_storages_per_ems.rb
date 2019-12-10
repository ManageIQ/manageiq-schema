class SplitStoragesPerEms < ActiveRecord::Migration[5.0]
  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class HostStorage < ActiveRecord::Base
    belongs_to :host,    :class_name => "::SplitStoragesPerEms::Host"
    belongs_to :storage, :class_name => "::SplitStoragesPerEms::Storage"
  end

  class Storage < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    Storage.in_my_region.find_each do |storage|
      # First we need to group HostStorage records by their ems_id and ems_ref since these will
      # form the new Storage records. Once the Storage records are created we can link them
      # to the hosts through these HostStorage records.
      host_storages_by_ems_id_and_ems_ref = HostStorage.includes(:host).where(:storage_id => storage.id).group_by do |hs|
        ems_id            = hs.host&.ems_id
        datastore_ems_ref = hs.ems_ref || storage.ems_ref

        [ems_id, datastore_ems_ref]
      end

      storages_by_ems_id_and_ems_ref = {}
      all_ems_id_and_ems_refs        = host_storages_by_ems_id_and_ems_ref.keys

      # Re-use the existing storage record
      storage.ems_id, storage.ems_ref = all_ems_id_and_ems_refs.shift
      storage.save!
      storages_by_ems_id_and_ems_ref[[storage.ems_id, storage.ems_ref]] = storage

      # Create new storages for the rest of the ems_ids and ems_refs
      all_ems_id_and_ems_refs.each do |ems_id, ems_ref|
        next if ems_id.nil?

        new_storage = storage.attributes.except("id").merge("ems_id" => ems_id, "ems_ref" => ems_ref)
        storages_by_ems_id_and_ems_ref[[ems_id, ems_ref]] = Storage.create!(new_storage)
      end

      # Link up the host_storage records to the new storages
      host_storages_by_ems_id_and_ems_ref.each_key do |ems_id, ems_ref|
        next if ems_id.nil?

        # Connect all of the HostStorage records to the new Storage record
        host_storages_ids = host_storages_by_ems_id_and_ems_ref[[ems_id, ems_ref]].map(&:id)
        storage = storages_by_ems_id_and_ems_ref[[ems_id, ems_ref]]

        HostStorage.where(:id => host_storages_ids).update_all(:storage_id => storage.id)
      end
    end
  end

  def down
    Storage.in_my_region.find_each do |storage|
      # Set the ems_ref back on the HostStorage records
      HostStorage.where(:storage_id => storage.id).update_all(:ems_ref => storage.ems_ref)
    end
  end
end
