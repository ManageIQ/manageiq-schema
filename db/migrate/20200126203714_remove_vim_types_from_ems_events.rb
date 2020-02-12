class RemoveVimTypesFromEmsEvents < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  include MigrationHelper

  class EventStream < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing Vim Types from EmsEvents") do
      base_relation = EventStream.in_my_region.where(:source => "VC")
        .where("full_data LIKE ?", "%hash-with-ivars:VimHash%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation
          .limit(50_000)
          .update_all("full_data = REGEXP_REPLACE(full_data, '!ruby/(string|array|hash-with-ivars):Vim(Hash|String|Array)', '!ruby/\\1:\\2', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end

  def down
    say_with_time("Restoring Vim Types in EmsEvents") do
      base_relation = EventStream.in_my_region.where(:source => "VC")
        .where("full_data LIKE ?", "%hash-with-ivars:Hash%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation
          .limit(50_000)
          .update_all("full_data = REGEXP_REPLACE(full_data, '!ruby/(string|array|hash-with-ivars):(Hash|String|Array)', '!ruby/\\1:Vim\\2', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end
end
