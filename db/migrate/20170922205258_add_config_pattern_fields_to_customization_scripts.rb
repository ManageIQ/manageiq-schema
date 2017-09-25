class AddConfigPatternFieldsToCustomizationScripts < ActiveRecord::Migration[5.0]
  def change
    add_column :customization_scripts, :description, :string
    add_column :customization_scripts, :user_defined, :boolean
    add_column :customization_scripts, :in_use, :boolean
  end
end
