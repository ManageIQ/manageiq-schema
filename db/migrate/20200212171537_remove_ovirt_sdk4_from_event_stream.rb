class RemoveOvirtSdk4FromEventStream < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  include MigrationHelper

  class EventStream < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing OvirtSDK4 types from EmsEvents") do
      base_relation = EventStream.in_my_region.where(:source => "RHEVM")
        .where("full_data LIKE ?", "%object:OvirtSDK4::Event%")

      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(50_000)
          .update_all("full_data = REGEXP_REPLACE(full_data, '!ruby/object:OvirtSDK4::\\w+', '!ruby/object:Hash', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end
end
