class RemoveMigrationFeature < ActiveRecord::Migration[5.2]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class MiqRequest < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class MiqRequestTask < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Job < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Vm < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class ConversionHost < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class CustomAttribute < ActiveRecord::Base; end
  class Tag < ActiveRecord::Base; end
  class Tagging < ActiveRecord::Base; end

  def up
    # These classes inherit from core classes, so we don't drop the tables.
    # Instead we remove the records.
    ServiceTemplate.where(:type => "ServiceTemplateTransformationPlan").delete_all
    MiqRequest.where(:type => "ServiceTemplateTransformationPlanRequest").delete_all
    MiqRequestTask.where(:type => "ServiceTemplateTransformationPlanTask").delete_all
    Job.where(:type => "InfraConversionJob").delete_all

    # Conversion hosts can be either a RHV host or VM, or an OpenStack VM
    # We need to clean the resources, i.e. remove tags and custom attributes
    tag_ids = [
      Tag.find_by(:name => '/managed/v2v_transformation_host/false')&.id,
      Tag.find_by(:name => '/managed/v2v_transformation_host/true')&.id,
      Tag.find_by(:name => '/managed/v2v_transformation_method/ssh')&.id,
      Tag.find_by(:name => '/managed/v2v_transformation_method/vddk')&.id
    ].compact
    tag_ids.each do |tag_id|
      Tagging.where(:tag_id => tag_id).delete_all
      Tag.find(tag_id).delete
    end

    ConversionHost.all.each do |chost|
      CustomAttribute.where(
        :resource_id   => chost.resource_id,
        :resource_type => chost.resource_type,
        :name          => 'TransformationIPAddress'
      ).delete_all
    end

    # These tables are used only by Migration feature, so we can drop them.
    drop_table :conversion_hosts
    drop_table :transformation_mappings
    drop_table :transformation_mapping_items
  end
end
