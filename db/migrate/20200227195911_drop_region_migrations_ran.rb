class DropRegionMigrationsRan < ActiveRecord::Migration[5.1]
  def up
    remove_column :miq_regions, :migrations_ran
  end

  def down
    add_column :miq_regions, :migrations_ran, :string, :array => true
  end
end
