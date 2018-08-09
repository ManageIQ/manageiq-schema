class AddInternalToServiceTemplate < ActiveRecord::Migration[5.0]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    include ReservedMigrationMixin
    include MigrationStubHelper
  end

  def up
    add_column :service_templates, :internal, :boolean

    say_with_time("Migrate data from reserved table to ServiceTemplate") do
      ServiceTemplate.includes(:reserved_rec).where(:type => "ServiceTemplateTransformationPlan").each do |st|
        st.reserved_hash_migrate(:internal)
      end
    end

    say_with_time("Set ServiceTemplate internal") do
      ServiceTemplate.where(:type => "ServiceTemplateTransformationPlan").update_all(:internal => true)
    end
  end

  def down
    say_with_time("Migrate data from ServiceTemplate to reserved table") do
      ServiceTemplate.includes(:reserved_rec).where(:type => "ServiceTemplateTransformationPlan").each do |st|
        st.reserved_hash_set(:internal, st.internal)
        st.save!
      end
    end

    remove_column :service_templates, :internal
  end
end
