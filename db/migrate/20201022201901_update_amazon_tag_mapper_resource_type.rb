class UpdateAmazonTagMapperResourceType < ActiveRecord::Migration[5.2]
  class ProviderTagMapping < ActiveRecord::Base
  end

  def up
    say_with_time("Update ProviderTagMapping Vm label") do
      ProviderTagMapping.where(:labeled_resource_type => "Vm").update_all(:labeled_resource_type => "VmAmazon")
    end
    say_with_time("Update ProviderTagMapping Image label") do
      ProviderTagMapping.where(:labeled_resource_type => "Image").update_all(:labeled_resource_type => "ImageAmazon")
    end
  end

  def down
    say_with_time("Update ProviderTagMapping VmAmazon label") do
      ProviderTagMapping.where(:labeled_resource_type => "VmAmazon").update_all(:labeled_resource_type => "Vm")
    end
    say_with_time("Update ProviderTagMapping ImageAmazon label") do
      ProviderTagMapping.where(:labeled_resource_type => "ImageAmazon").update_all(:labeled_resource_type => "Image")
    end
  end
end
