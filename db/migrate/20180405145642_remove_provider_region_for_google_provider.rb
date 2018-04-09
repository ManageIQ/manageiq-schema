class RemoveProviderRegionForGoogleProvider < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing provider_region from ManageIQ::Providers::Google::CloudManager") do
      ExtManagementSystem.where(:type => 'ManageIQ::Providers::Google::CloudManager').update_all(:provider_region => nil)
    end
    say_with_time("Removing provider_region from ManageIQ::Providers::Google::NetworkManager") do
      ExtManagementSystem.where(:type => 'ManageIQ::Providers::Google::NetworkManager').update_all(:provider_region => nil)
    end
  end
end
