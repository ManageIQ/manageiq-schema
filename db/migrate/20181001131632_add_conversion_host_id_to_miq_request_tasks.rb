class AddConversionHostIdToMiqRequestTasks < ActiveRecord::Migration[5.0]
  class MiqRequestTask < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    include ActiveRecord::IdRegions

    serialize :options, Hash
    belongs_to :conversion_host, :class_name => "AddConversionHostIdToMiqRequestTasks::ConversionHost"
  end

  class ConversionHost < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    belongs_to :resource, :polymorphic => true
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    add_column :miq_request_tasks, :conversion_host_id, :bigint

    MiqRequestTask.in_my_region.where(:type => 'ServiceTemplateTransformationPlanTask').find_each do |task|
      host_id = task.options.delete(:transformation_host_id)
      next unless host_id
      host = Host.find_by(:id => host_id)
      if host.present?
        task.conversion_host = ConversionHost.find_or_create_by!(:resource => host) do |ch|
          ch.name                     = host.name
          ch.vddk_transport_supported = true
          ch.ssh_transport_supported  = false
        end
      end
      task.save!
    end
  end

  def down
    conversion_host_ids = []
    MiqRequestTask.in_my_region.where(:type => 'ServiceTemplateTransformationPlanTask').find_each do |task|
      next if task.conversion_host.nil?
      task.options[:transformation_host_id] = task.conversion_host.resource.id
      task.save!

      conversion_host_ids << task.conversion_host.id
    end

    ConversionHost.destroy(conversion_host_ids.uniq.compact)

    remove_column :miq_request_tasks, :conversion_host_id
  end
end
