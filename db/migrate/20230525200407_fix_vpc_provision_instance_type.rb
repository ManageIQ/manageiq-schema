class FixVpcProvisionInstanceType < ActiveRecord::Migration[6.1]
  class VmOrTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    self.table_name = "vms"
  end

  class MiqRequest < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled

    serialize :options, Hash
  end

  def up
    say_with_time("Setting instance_type for VPC provision requests") do
      MiqRequest.in_my_region.where(
        :type        => "MiqProvisionRequestTemplate",
        :source_type => "VmOrTemplate",
        :source_id   => VmOrTemplate.where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template")
      ).each do |miq_request|
        next if miq_request.options.key?(:instance_type) || !miq_request.options.key?(:provision_type)

        miq_request.options[:instance_type] = miq_request.options.delete(:provision_type)
        miq_request.save!
      end
    end
  end

  def down
    say_with_time("Setting provision_type for VPC provision requests") do
      MiqRequest.in_my_region.where(
        :type        => "MiqProvisionRequestTemplate",
        :source_type => "VmOrTemplate",
        :source_id   => VmOrTemplate.where(:type => "ManageIQ::Providers::IbmCloud::VPC::CloudManager::Template")
      ).each do |miq_request|
        next if !miq_request.options.key?(:instance_type) || miq_request.options.key?(:provision_type)

        miq_request.options[:provision_type] = miq_request.options.delete(:instance_type)
        miq_request.save!
      end
    end
  end
end
