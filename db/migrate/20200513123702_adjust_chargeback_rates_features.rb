class AdjustChargebackRatesFeatures < ActiveRecord::Migration[5.2]
  class MiqProductFeature < ActiveRecord::Base; end
  class MiqRolesFeature < ActiveRecord::Base; end

  OLD_FEATURES = %w[
    chargeback_rates_new
    chargeback_rates_edit
    chargeback_rates_copy
    chargeback_rates_delete
  ].freeze

  def up
    return if MiqProductFeature.none?

    say_with_time 'Adjusting chargeback rates features for the non-explorer views' do
      new_feature = MiqProductFeature.find_or_create_by!(:identifier => 'chargeback_rates_view')

      MiqRolesFeature.where(:miq_product_feature_id => old_feature_ids).each do |feature|
        MiqRolesFeature.create!(:miq_product_feature_id => new_feature.id, :miq_user_role_id => feature.miq_user_role_id)
      end
    end
  end

  def down
    return if MiqRolesFeature.none?

    say_with_time 'Adjusting chargeback rates features to explorer views' do
      admin_feature = MiqProductFeature.find_or_create_by!(:identifier => 'chargeback_rates_admin')

      MiqRolesFeature.where(:miq_product_feature_id => admin_feature.id).each do |feature|
        old_feature_ids.each do |id|
          MiqRolesFeature.create!(:miq_product_feature_id => id, :miq_user_role_id => feature.miq_user_role_id)
        end
      end
    end
  end

  private

  def old_feature_ids
    OLD_FEATURES.map { |identifier| MiqProductFeature.find_or_create_by!(:identifier => identifier) }
  end
end
