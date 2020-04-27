class SetReadOnlyFlag < ActiveRecord::Migration[5.1]
  class Dialog < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Updating Dialogs") do
      Dialog.in_my_region.where(:label => 'Transform VM').update_all(:system => true)
      Dialog.in_my_region.where.not(:label => 'Transform VM').update_all(:system => false)
    end
  end
end
