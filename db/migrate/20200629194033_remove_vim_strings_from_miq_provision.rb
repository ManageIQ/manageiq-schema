class RemoveVimStringsFromMiqProvision < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  include MigrationHelper

  class MiqRequestTask < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    regex_replace_column_value(MiqRequestTask.in_my_region, 'phase_context', '!ruby/string:VimString', '!ruby/string:String')
  end

  def down
    regex_replace_column_value(MiqRequestTask.in_my_region, 'phase_context', '!ruby/string:String', '!ruby/string:VimString')
  end
end
