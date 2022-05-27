class AddLastRefreshSuccessDate < ActiveRecord::Migration[6.0]
  def change
    add_column :ext_management_systems, :last_refresh_success_date, :datetime
  end
end
