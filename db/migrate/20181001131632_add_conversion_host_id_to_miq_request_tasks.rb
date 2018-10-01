class AddConversionHostIdToMiqRequestTasks < ActiveRecord::Migration[5.0]
  class MiqRequestTask < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    serialize :options, Hash
    belongs_to :conversion_host, :class_name => "AddConversionHostIdToMiqRequestTasks::ConversionHost"
  end

  class ServiceTemplateTransformationPlanTask < MiqRequestTask
  end

  class ConversionHost < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :service_template_transformation_plan_tasks, :class_name => "AddConversionHostIdToMiqRequestTasks::MiqRequestTask"
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    has_many :tags, :class_name => "AddConversionHostIdToMiqRequestTasks::Tag"
  end

  def up
    add_column :miq_request_tasks, :conversion_host_id, :bigint

    ServiceTemplateTransformationPlanTask.all.reject { |task| task.options[:transformation_host_id].nil? }.each do |task|
      host = Host.find_by(:id => task.options[:transformation_host_id])
      task.conversion_host = ConversionHost.where(:id => task.options[:transformation_host_id]).first_or_create do |ch|
        ch.name                     = host.name
        ch.resource_type            = host.type
        ch.resource_id              = host.id
        ch.address                  = host.ipaddress
        ch.vddk_transport_supported = true
        ch.ssh_transport_supported  = false
      end
      task.options.delete(:transformation_host_id)
      task.save!
    end
  end

  def down
    ServiceTemplateTransformationPlanTask.all.select { |task| task.conversion_host.present? }.each do |task|
      task.options[:transformation_host_id] = task.conversion_host.id
      ConversionHost.find(task.conversion_host.id).destroy!
      task.save!
    end

    remove_column :miq_request_tasks, :conversion_host_id
  end
end
