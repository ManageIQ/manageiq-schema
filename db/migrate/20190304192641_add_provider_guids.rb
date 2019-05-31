class AddProviderGuids < ActiveRecord::Migration[5.0]
  class Provider < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Update provider guid values") do
      Provider.in_my_region.where(:guid => nil).each do |provider|
        provider.update_attributes!(:guid => SecureRandom.uuid)
      end
    end
  end
end
