class RemoveVimTypesFromEmsEvents < ActiveRecord::Migration[5.1]
  class EventStream < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing Vim Types from EmsEvents") do
      EventStream.in_my_region.where(:source => "VC")
        .where("full_data LIKE ?", "%hash-with-ivars:VimHash%")
        .update_all("full_data = REGEXP_REPLACE(full_data, '!ruby/(string|array|hash-with-ivars):Vim(Hash|String|Array)', '!ruby/\\1:\\2', 'g')")
    end
  end
end
