class AddOptionsToExtManagementSystem < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :custom_attributes,
             :as         => :resource,
             :dependent  => :destroy,
             :class_name => 'AddOptionsToExtManagementSystem::CustomAttribute'
    serialize :options
  end

  class CustomAttribute < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    belongs_to :resource, :polymorphic => true
    serialize :serialized_value
  end

  def up
    add_column :ext_management_systems, :options, :text
    say_with_time("Migrating Kubernetes provider options") do
      ExtManagementSystem
        .where(:type => ["ManageIQ::Providers::Kubernetes::ContainerManager",
                         "ManageIQ::Providers::Openshift::ContainerManager"])
        .each do |cp|
        migrated_options = Hash[
          cp.custom_attributes.where(:section => 'cluster_settings',
                                     :name    => %w(no_proxy http_proxy https_proxy))
            .map { |ca| [ca.name.to_sym, ca.value] }]
        cp.update(:options => {:image_inspector_options => migrated_options})
      end
      CustomAttribute.where(:section => 'cluster_settings',
                            :name    => %w(no_proxy http_proxy https_proxy)).delete_all
    end
  end

  def down
    say_with_time("Migrating Kubernetes provider options") do
      ExtManagementSystem
        .where(:type => ["ManageIQ::Providers::Kubernetes::ContainerManager",
                         "ManageIQ::Providers::Openshift::ContainerManager"])
        .each do |cp|
        options = cp.options
        %w(no_proxy http_proxy https_proxy).each do |opt|
          if options[:image_inspector_options].keys.include?(opt.to_sym)
            cp.custom_attributes.create(:section => 'cluster_settings',
                                        :name    => opt,
                                        :value   => options[:image_inspector_options][opt.to_sym])
          end
        end
      end
    end
    remove_column :ext_management_systems, :options
  end
end
