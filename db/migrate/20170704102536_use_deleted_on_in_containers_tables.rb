class UseDeletedOnInContainersTables < ActiveRecord::Migration[5.0]
  class ContainerDefinition < ActiveRecord::Base
  end

  class ContainerGroup < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class ContainerImage < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class ContainerProject < ActiveRecord::Base
  end

  class ContainerNode < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Container < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def disconnect_to_soft_delete(model)
    model.where(:deleted_on => nil, :ems_id => nil).update_all(:deleted_on => Time.now.utc)
    model.where.not(:deleted_on => nil).where.not(:ems_id => nil).update_all(:deleted_on => nil)
    model.where.not(:deleted_on => nil).update_all("ems_id = old_ems_id")
  end

  def soft_delete_to_disconnect(model)
    model.where.not(:deleted_on => nil).update_all(:ems_id => nil)
  end

  MODEL_CLASSES = [
    ContainerDefinition,
    ContainerGroup,
    ContainerImage,
    ContainerProject,
    ContainerNode,
    Container,
  ].freeze

  def up
    MODEL_CLASSES.each do |model_class|
      say_with_time("Change ':deleted_on not nil' :ems_id to :old_ems_id for #{model_class}") do
        disconnect_to_soft_delete(model_class)
      end
    end
  end

  def down
    MODEL_CLASSES.each do |model_class|
      say_with_time("Change ':deleted_on not nil' :ems_id to nil for #{model_class}") do
        soft_delete_to_disconnect(model_class)
      end
    end
  end
end
