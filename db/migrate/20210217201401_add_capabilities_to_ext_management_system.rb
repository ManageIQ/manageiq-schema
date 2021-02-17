class AddCapabilitiesToExtManagementSystem < ActiveRecord::Migration[6.0]
  def change
    add_column :ext_management_systems, :capabilities, :jsonb, :default => {}
  end
end
