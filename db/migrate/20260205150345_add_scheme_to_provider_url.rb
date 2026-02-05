class AddSchemeToProviderUrl < ActiveRecord::Migration[7.2]
  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  class Provider < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def change
    # AWX defaults to non-ssl and the Provider would use http if no scheme was provided.
    # In order to use https:// with AWX you would have had to specify in the URL which would
    # be bypassed by the url LIKE clause checking for a scheme below.
    say_with_time("Adding http:// scheme to Awx::Provider urls") do
      providers = Provider.in_my_region.where(:type => "ManageIQ::Providers::Awx::Provider")
      Endpoint.in_my_region
              .where(:resource_type => "Provider", :resource_id => providers)
              .where.not(:url => nil)
              .where.not("url LIKE ?", "%://%")
              .update_all(["url = CONCAT(?, url)", "http://"])
    end

    # Ansible Tower/AAP defaults to ssl so we set https as the default scheme.
    say_with_time("Adding https:// scheme to AnsibleTower::Provider urls") do
      providers = Provider.in_my_region.where(:type => "ManageIQ::Providers::AnsibleTower::Provider")
      Endpoint.in_my_region
              .where(:resource_type => "Provider", :resource_id => providers)
              .where.not(:url => nil)
              .where.not("url LIKE ?", "%://%")
              .update_all(["url = CONCAT(?, url)", "https://"])
    end
  end
end
