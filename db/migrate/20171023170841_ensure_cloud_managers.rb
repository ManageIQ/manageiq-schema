class EnsureCloudManagers < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base; end
  class BaseManager < ExtManagementSystem; end
  class Settings < ActiveRecord::Base; end

  class ManageIQ
    class Providers
      class CloudManager < ActiveRecord::Base
        def ensure_managers
          build_network_manager unless network_manager
          network_manager.name = "#{name} Network Manager"

          build_ebs_storage_manager unless ebs_storage_manager
          ebs_storage_manager.name = "#{name} EBS Storage Manager"

          if Settings.prototype.amazon.s3
            build_s3_storage_manager unless s3_storage_manager
            s3_storage_manager.name = "#{name} S3 Storage Manager"
          end

          ensure_managers_zone_and_provider_region
        end

        def ensure_managers_zone_and_provider_region
          if network_manager
            network_manager.zone_id         = zone_id
            network_manager.provider_region = provider_region
          end

          if ebs_storage_manager
            ebs_storage_manager.zone_id         = zone_id
            ebs_storage_manager.provider_region = provider_region
          end

          if s3_storage_manager
            s3_storage_manager.zone_id         = zone_id
            s3_storage_manager.provider_region = provider_region
          end
        end
      end
    end
  end

  def up
    ManageIQ::Providers::CloudManager.all.each { |x| x.send(:ensure_managers); x.save!; }
  end
end
