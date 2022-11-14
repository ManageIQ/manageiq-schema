class RemoveVimStringsFromCustomAttributes < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  include MigrationHelper

  class CustomAttribute < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Removing VimStrings from CustomAttribute") do
      base_relation = CustomAttribute.in_my_region.where("serialized_value LIKE ?", "%ruby/string:VimString%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(50_000).update_all("serialized_value = REGEXP_REPLACE(serialized_value, '!ruby/string:VimString', '!ruby/string:String', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end

  def down
    say_with_time("Restoring VimStrings from CustomAttribute") do
      base_relation = CustomAttribute.in_my_region.where("serialized_value LIKE ?", "%ruby/string:String%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(50_000).update_all("serialized_value = REGEXP_REPLACE(serialized_value, '!ruby/string:String', '!ruby/string:VimString', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end
end
