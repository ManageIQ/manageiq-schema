class AddStiToContainerImage < ActiveRecord::Migration[5.0]
  class ContainerImage < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end


  def up
    add_column :container_images, :type, :string
    add_column :container_images, :ems_ref, :string
    say_with_time("Updating type column for ContainerImage") do
      ContainerImage.where(:size => nil).update_all(:type => "ContainerImage")
      ContainerImage.where.not(:size => nil).update_all(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
    end
  end

  def down
    remove_column :container_images, :type
    remove_column :container_images, :ems_ref
  end
end
