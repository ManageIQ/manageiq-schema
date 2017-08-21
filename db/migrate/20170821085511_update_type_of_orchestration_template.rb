class UpdateTypeOfOrchestrationTemplate < ActiveRecord::Migration[5.0]
  class OrchestrationTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Updating type column for OrchestrationTemplate") do
      OrchestrationTemplate
        .where(:type => 'OrchestrationTemplateCfn')
        .update_all(:type => 'ManageIQ::Providers::Amazon::CloudManager::OrchestrationTemplate')

      OrchestrationTemplate
        .where(:type => 'OrchestrationTemplateHot')
        .update_all(:type => 'ManageIQ::Providers::Openstack::CloudManager::OrchestrationTemplate')

      OrchestrationTemplate
        .where(:type => 'OrchestrationTemplateVnfd')
        .update_all(:type => 'ManageIQ::Providers::Openstack::CloudManager::VnfdTemplate')

      OrchestrationTemplate
        .where(:type => 'OrchestrationTemplateAzure')
        .update_all(:type => 'ManageIQ::Providers::Azure::CloudManager::OrchestrationTemplate')
    end
  end

  def down
    say_with_time("Reverting type column for OrchestrationTemplate") do
      OrchestrationTemplate
        .where(:type => 'ManageIQ::Providers::Amazon::CloudManager::OrchestrationTemplate')
        .update_all(:type => 'OrchestrationTemplateCfn')

      OrchestrationTemplate
        .where(:type => 'ManageIQ::Providers::Openstack::CloudManager::OrchestrationTemplate')
        .update_all(:type => 'OrchestrationTemplateHot')

      OrchestrationTemplate
        .where(:type => 'ManageIQ::Providers::Openstack::CloudManager::VnfdTemplate')
        .update_all(:type => 'OrchestrationTemplateVnfd')

      OrchestrationTemplate
        .where(:type => 'ManageIQ::Providers::Azure::CloudManager::OrchestrationTemplate')
        .update_all(:type => 'OrchestrationTemplateAzure')
    end
  end
end
