class RemoveVimStringsFromCustomAttributes < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  include MigrationHelper

  class CustomAttribute < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    regex_replace_column_value(CustomAttribute.in_my_region, 'serialized_value', '!ruby/string:VimString', '!ruby/string:String')
  end

  def down
    regex_replace_column_value(CustomAttribute.in_my_region, 'serialized_value', '!ruby/string:String', '!ruby/string:VimString')
  end
end
