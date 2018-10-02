class AddConversionHostIdToMiqRequestTasks < ActiveRecord::Migration[5.0]
  class MiqRequestTask < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    serialize :options, Hash
    belongs_to :conversion_host, :class_name => "AddConversionHostIdToMiqRequestTasks::ConversionHost"
  end

  class ConversionHost < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    add_column :miq_request_tasks, :conversion_host_id, :bigint

    MiqRequestTask.where(:type => 'ServiceTemplateTransformationPlanTask').each do |task|
      host_id = task.options[:transformation_host_id]
      next unless host_id
      host = Host.find_by(:id => host_id)
      next if host.nil?
      task.conversion_host = ConversionHost.find_or_create_by!(:resource_id => host.id, :resource_type => host.type) do |ch|
        ch.name                     = host.name
        ch.vddk_transport_supported = true
        ch.ssh_transport_supported  = false
      end
      task.options.delete(:transformation_host_id)
      task.save!
    end
  end

  def down
    MiqRequestTask.where(:type => 'ServiceTemplateTransformationPlanTask').each do |task|
      next unless task.conversion_host
      task.options[:transformation_host_id] = task.conversion_host.resource_id
      ConversionHost.find(task.conversion_host.id).destroy!
      task.save!
    end

    remove_column :miq_request_tasks, :conversion_host_id
  end
end
