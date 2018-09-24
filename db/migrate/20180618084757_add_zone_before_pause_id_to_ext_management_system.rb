class AddZoneBeforePauseIdToExtManagementSystem < ActiveRecord::Migration[5.0]
  def change
    add_reference :ext_management_systems, :zone_before_pause, :type => :bigint, :index => true
  end
end
