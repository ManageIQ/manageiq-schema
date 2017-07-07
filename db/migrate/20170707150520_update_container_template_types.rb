class UpdateContainerTemplateTypes < ActiveRecord::Migration[5.0]
  class ContainerTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Updating type column for ContainerTemplate") do
      ContainerTemplate.update_all(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerTemplate")
    end
  end
end
