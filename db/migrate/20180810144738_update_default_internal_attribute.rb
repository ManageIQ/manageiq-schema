class UpdateDefaultInternalAttribute < ActiveRecord::Migration[5.0]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Set ServiceTemplate internal") do
      ServiceTemplate.where.not(:type => "ServiceTemplateTransformationPlan").update_all(:internal => false)
    end
  end
end
