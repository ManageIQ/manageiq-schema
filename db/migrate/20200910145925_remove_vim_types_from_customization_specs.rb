class RemoveVimTypesFromCustomizationSpecs < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  include MigrationHelper

  class CustomizationSpec < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Removing Vim Types from CustomizationSpecs") do
      base_relation = CustomizationSpec.in_my_region.where("spec LIKE ?", "%hash-with-ivars:VimHash%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation
                .limit(50_000)
                .update_all("spec = REGEXP_REPLACE(spec, '!ruby/(string|array|hash-with-ivars):Vim(Hash|String|Array)', '!ruby/\\1:\\2', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end

  def down
    say_with_time("Restoring Vim Types in CustomizationSpecs") do
      base_relation = CustomizationSpec.in_my_region.where("spec LIKE ?", "%hash-with-ivars:Hash%")
      say_batch_started(base_relation.size)

      loop do
        count = base_relation
                .limit(50_000)
                .update_all("spec = REGEXP_REPLACE(spec, '!ruby/(string|array|hash-with-ivars):(Hash|String|Array)', '!ruby/\\1:Vim\\2', 'g')")
        break if count == 0

        say_batch_processed(count)
      end
    end
  end
end
