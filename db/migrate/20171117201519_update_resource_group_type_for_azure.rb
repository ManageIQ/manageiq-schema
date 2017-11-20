class UpdateResourceGroupTypeForAzure < ActiveRecord::Migration[5.0]
  class ResourceGroup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Update Azure resource group type") do
      ResourceGroup.update_all(:type => 'ManageIQ::Providers::Azure::ResourceGroup')
    end
  end

  def down
    say_with_time("Set Azure resource group type to base value") do
      ResourceGroup.update_all(:type => 'ResourceGroup')
    end
  end
end
