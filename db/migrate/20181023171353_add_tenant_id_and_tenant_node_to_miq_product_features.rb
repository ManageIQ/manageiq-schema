class AddTenantIdAndTenantNodeToMiqProductFeatures < ActiveRecord::Migration[5.0]
  def change
    add_reference :miq_product_features, :tenant, :type => :bigint, :index => true
  end
end
