class RemoveVimStringFromMiqRequestTaskOptions < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  include MigrationHelper

  class MiqRequestTask < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing VimStrings from MiqRequestTask") do
      base_relation = MiqRequestTask.in_my_region.where("options LIKE ?", "%ruby/string:VimString%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(50_000).update_all("options = REGEXP_REPLACE(options, '!ruby/string:VimString', '!ruby/string:String', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end

  def down
    say_with_time("Restoring VimStrings from MiqRequestTask") do
      base_relation = MiqRequestTask.in_my_region.where("options LIKE ?", "%ruby/string:String%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(50_000).update_all("options = REGEXP_REPLACE(options, '!ruby/string:String', '!ruby/string:VimString', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end
end
