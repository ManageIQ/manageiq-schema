class RemoveVimStringsFromNotifications < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  include MigrationHelper

  class Notification < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    regex_replace_column_value(Notification.in_my_region, 'options', '!ruby/string:VimString', '!ruby/string:String')
  end

  def down
    regex_replace_column_value(Notification.in_my_region, 'options', '!ruby/string:String', '!ruby/string:VimString')
  end
end
