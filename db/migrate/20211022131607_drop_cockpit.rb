class DropCockpit < ActiveRecord::Migration[6.0]
  class AssignedServerRole < ActiveRecord::Base; end

  class ServerRole < ActiveRecord::Base; end

  class SettingsChange < ActiveRecord::Base; end

  class MiqUserRole < ActiveRecord::Base; end

  class MiqRolesFeature < ApplicationRecord; end

  class MiqProductFeature < ApplicationRecord
    # habtm :miq_user_roles :join_table => MiqRolesFeature
  end

  def up
    say_with_time("Deleting cockpit configuration") do
      if (cockpit = ServerRole.find_by(:name => "cockpit_ws"))
        AssignedServerRole.where(:server_role_id => cockpit.id).delete_all
        cockpit.delete
      end

      SettingsChange.where("key LIKE '%/cockpit_ws_worker/%'").delete_all

      if (feature = MiqProductFeature.find_by(:identifier => "cockpit_console"))
        MiqRolesFeature.where(:miq_product_feature_id => feature.id).delete_all
        feature.delete
      end
    end
  end
end
