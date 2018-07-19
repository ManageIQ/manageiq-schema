class AddInternalToServiceTemplate < ActiveRecord::Migration[5.0]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    add_column :service_templates, :internal, :boolean

    say_with_time("Set ServiceTemplate internal") do
      ServiceTemplate.where(:type => "ServiceTemplateTransformationPlan").update_all(:internal => true)
    end
  end

  def down
    remove_column :service_templates, :internal
  end
end
