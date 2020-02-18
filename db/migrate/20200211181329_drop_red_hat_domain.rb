class DropRedHatDomain < ActiveRecord::Migration[5.1]
  class MiqAeNamespace < ActiveRecord::Base; end
  class MiqAeField < ActiveRecord::Base; end
  class MiqAeMethod < ActiveRecord::Base; end
  class MiqAeInstance < ActiveRecord::Base; end
  class MiqAeValue < ActiveRecord::Base; end
  class MiqAeClass < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time('Remove RedHat domain') do
      domain = MiqAeNamespace.find_by(:name => 'RedHat', :parent_id => nil)
      return unless domain

      domain_ids_list = fetch_child_namespace_ids(domain.id)
      ae_classes_id_list = MiqAeClass.where(:namespace_id => domain_ids_list).pluck(:id)
      instances_id_list = MiqAeInstance.where(:class_id => ae_classes_id_list).pluck(:id)

      MiqAeValue.where(:instance_id => instances_id_list).destroy_all
      MiqAeField.where(:class_id => ae_classes_id_list).destroy_all
      MiqAeMethod.where(:class_id => ae_classes_id_list).destroy_all
      MiqAeInstance.where(:class_id => ae_classes_id_list).destroy_all
      MiqAeClass.where(:namespace_id => domain_ids_list).destroy_all
      MiqAeNamespace.where(:id => domain_ids_list).destroy_all
    end
  end

  def fetch_child_namespace_ids(namespace_ids)
    return [] if namespace_ids.blank?

    ids = MiqAeNamespace.where(:parent_id => namespace_ids).pluck(:id)
    fetch_child_namespace_ids(ids) + Array(namespace_ids)
  end
end
