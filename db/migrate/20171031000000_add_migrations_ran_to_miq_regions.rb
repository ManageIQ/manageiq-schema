class AddMigrationsRanToMiqRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_regions, :migrations_ran, :string, :array => true
  end
end
