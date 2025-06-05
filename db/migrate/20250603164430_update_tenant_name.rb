class UpdateTenantName < ActiveRecord::Migration[7.0]
  class SettingsChange < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class Tenant < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def change
    say_with_time("Updating root tenant's name from settings") do
      sc = SettingsChange.in_my_region.find_by(:key => "/server/company")
      Tenant.in_my_region.find_by(:ancestry => nil, :use_config_for_attributes => true)&.update(:name => sc&.value || "My Company", :use_config_for_attributes => false)
      SettingsChange.in_my_region.where(:key => "/server/company").destroy_all
    end
  end

  def revert
    # no real way to revert
    # the record remains as :use_config_for_attributes => false, and Tenant.root.name is used
  end
end
