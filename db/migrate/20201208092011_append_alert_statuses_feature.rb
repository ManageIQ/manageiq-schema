class AppendAlertStatusesFeature < ActiveRecord::Migration[5.2]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  def up
    return if MiqProductFeature.none?

    alert = MiqProductFeature.find_or_create_by!(:identifier => 'alert')
    alert_status = MiqProductFeature.find_or_create_by!(:identifier => 'alert_status')

    MiqRolesFeature.where(:miq_product_feature_id => alert.id).each do |feature|
      MiqRolesFeature.create!(:miq_product_feature_id => alert_status.id, :miq_user_role_id => feature.miq_user_role_id)
    end
  end

  def down
    # not reversible
  end
end
