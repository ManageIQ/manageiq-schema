class AddSchemeToProviderUrl < ActiveRecord::Migration[7.2]
  PROVIDER_TYPES = %w[ManageIQ::Providers::Awx::Provider ManageIQ::Providers::AnsibleTower::Provider].freeze

  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class Provider < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def change
    say_with_time("Adding http:// scheme to Provider url") do
      providers = Provider.in_my_region.where(:type => PROVIDER_TYPES)
      Endpoint.in_my_region
              .where(:resource_type => "Provider", :resource_id => providers)
              .where.not(:url => nil)
              .where.not("url LIKE ?", "%://%")
              .update_all(["url = CONCAT(?, url)", "http://"])
    end
  end
end
