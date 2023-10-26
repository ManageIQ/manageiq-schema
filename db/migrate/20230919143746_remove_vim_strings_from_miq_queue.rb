class RemoveVimStringsFromMiqQueue < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  include MigrationHelper

  class MiqQueue < ActiveRecord::Base
  end

  def up
    regex_replace_column_value(MiqQueue, 'args', '!ruby/string:VimString', '!ruby/string:String')
    regex_replace_column_value(MiqQueue, 'args', '!ruby/hash-with-ivars:VimHash', '!ruby/hash-with-ivars:Hash')
  end

  # this is very old, not rolling back
  def down
  end
end
