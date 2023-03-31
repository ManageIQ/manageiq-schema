class SetResourceActionType < ActiveRecord::Migration[6.1]
  class ResourceAction < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Set ResourceAction#type") do
      ResourceAction.in_my_region.update_all(:type => "ResourceActionAutomate")
    end
  end

  def down
    say_with_time("Clear ResourceAction#type") do
      ResourceAction.in_my_region.update_all(:type => nil)
    end
  end
end
