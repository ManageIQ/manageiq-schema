class DowncaseResourceGroupEmsRefForAzure < ActiveRecord::Migration[5.0]
  class ResourceGroup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Downcase ems_ref for Azure resource groups") do
      ResourceGroup.update_all("ems_ref = lower(ems_ref)")
    end
  end
end
