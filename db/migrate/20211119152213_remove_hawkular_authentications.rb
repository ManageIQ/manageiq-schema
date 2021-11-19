class RemoveHawkularAuthentications < ActiveRecord::Migration[6.0]
  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions
  end

  def up
    say_with_time("Delete all hawkular authentications and endpoints") do
      Authentication.in_my_region.where(:authtype => "hawkular").delete_all
      Endpoint.in_my_region.where(:role => "hawkular").delete_all
    end
  end
end
