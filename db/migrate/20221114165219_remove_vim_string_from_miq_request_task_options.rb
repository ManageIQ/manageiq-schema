class RemoveVimStringFromMiqRequestTaskOptions < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  include MigrationHelper

  class MiqRequestTask < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    regex_replace_column_value(MiqRequestTask, 'options', '!ruby/string:VimString', '!ruby/string:String')
  end

  def down
    regex_replace_column_value(MiqRequestTask, 'options', '!ruby/string:String', '!ruby/string:VimString')
  end
end
