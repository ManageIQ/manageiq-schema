class AddDeletedOnToServiceTemplate < ActiveRecord::Migration[5.0]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    include ReservedMigrationMixin
    include MigrationStubHelper
  end

  def up
    add_column :service_templates, :deleted_on, :datetime

    say_with_time("Migrate data from reserved table to service_templates") do
      ServiceTemplate.includes(:reserved_rec).each do |st|
        st.reserved_hash_migrate(:deleted_on)
      end
    end
  end

  def down
    say_with_time("Migrate data from service_templates to reserved table") do
      ServiceTemplate.includes(:reserved_rec).each do |st|
        st.reserved_hash_set(:deleted_on, st.deleted_on)
        st.save!
      end
    end

    remove_column :service_templates, :deleted_on
  end
end
