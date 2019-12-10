require_migration

class SplitStoragesPerEms
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end
  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    has_many :host_storages, :class_name => "::SplitStoragesPerEms::HostStorage"
    has_many :storages, :through => :host_storages
  end
end

describe SplitStoragesPerEms do
  let(:ems_stub)          { migration_stub(:ExtManagementSystem) }
  let(:host_stub)         { migration_stub(:Host) }
  let(:host_storage_stub) { migration_stub(:HostStorage) }
  let(:storage_stub)      { migration_stub(:Storage) }

  migration_context :up do
    context "with a single storage" do
      let(:storage) { storage_stub.create!(:ems_ref => "datastore-1") }

      context "and a single active host" do
        let(:ems) { ems_stub.create! }
        let!(:host) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id)
          end
        end

        it "doesn't touch the storage record" do
          migrate
          expect(storage_stub.count).to eq(1)
        end

        it "host is still linked to the storage" do
          migrate
          expect(host.reload.storages.first).to eq(storage_stub.first)
        end
      end

      context "and two active hosts" do
        let(:ems) { ems_stub.create! }
        let!(:host_1) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id)
          end
        end
        let!(:host_2) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id)
          end
        end

        it "doesn't touch the storage record" do
          migrate
          expect(storage_stub.count).to eq(1)
        end

        it "both hosts are still linked to the storage" do
          migrate

          storage = storage_stub.first
          expect(host_1.reload.storages.first).to eq(storage)
          expect(host_2.reload.storages.first).to eq(storage)
        end
      end

      context "with different datastores in the same EMS" do
        let(:ems) { ems_stub.create! }
        let!(:host_1) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id, :ems_ref => "datastore-1")
          end
        end
        let!(:host_2) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id, :ems_ref => "datastore-2")
          end
        end

        it "creates two storages" do
          migrate
          expect(storage_stub.count).to eq(2)
        end

        it "links the right host to the right datastore" do
          migrate
          expect(host_1.reload.storages.first.ems_ref).to eq("datastore-1")
          expect(host_2.reload.storages.first.ems_ref).to eq("datastore-2")
        end
      end

      context "with different datastores in different EMSs" do
        let(:ems_1) { ems_stub.create! }
        let(:ems_2) { ems_stub.create! }
        let!(:host_1) do
          host_stub.create!(:ems_id => ems_1.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id, :ems_ref => "datastore-1")
          end
        end
        let!(:host_2) do
          host_stub.create!(:ems_id => ems_2.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id, :ems_ref => "datastore-2")
          end
        end

        it "creates two storages" do
          migrate
          expect(storage_stub.count).to eq(2)
          expect(storage_stub.pluck(:ems_id)).to match_array([ems_1.id, ems_2.id])
        end

        it "links the right host to the right datastore" do
          migrate

          expect(host_1.reload.storages.first.ems_id).to eq(host_1.ems_id)
          expect(host_2.reload.storages.first.ems_id).to eq(host_2.ems_id)
        end

        context "with an archived host" do
          let!(:archived_host) do
            host_stub.create!.tap do |h|
              host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id, :ems_ref => "datastore-3")
            end
          end

          it "doesn't create a storage record for the archived host" do
            migrate

            expect(storage_stub.count).to eq(2)
          end
        end
      end
    end
  end

  migration_context :down do
    context "with a single storage" do
      let(:storage) { storage_stub.create!(:ems_ref => "datastore-1") }

      context "and a single active host" do
        let(:ems) { ems_stub.create! }
        let!(:host) do
          host_stub.create!(:ems_id => ems.id).tap do |h|
            host_storage_stub.create!(:host_id => h.id, :storage_id => storage.id)
          end
        end

        it "links hosts to the old storage" do
          migrate
          expect(host.reload.host_storages.first.storage).to eq(storage)
        end

        it "sets the ems_ref" do
          migrate
          expect(host.reload.host_storages.first.ems_ref).to eq(storage.ems_ref)
        end
      end
    end
  end
end
