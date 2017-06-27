class UpdateContainerImageTypes < ActiveRecord::Migration[5.0]
  class ContainerImage < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Updating type column for ContainerImage") do
      ContainerImage.where(:size => nil).update_all(:type => "ContainerImage")
      ContainerImage.where.not(:size => nil).update_all(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
    end
  end
end
