class CopyCloudTenantsEmsRefToTenants < ActiveRecord::Migration[5.1]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Tenant < ActiveRecord::Base; end

  class CloudTenant < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Copying CloudTenant#ems_ref or ExtManagementSystem#guid to Tenant#ems_ref") do
      Tenant.where.not(:source_id => nil).each do |tenant|
        case tenant.source_type
        when "CloudTenant"
          source_scope = CloudTenant.where(:id => tenant.source_id)
          if source_scope.exists?
            tenant.update_attributes(:ems_ref => source_scope.first.ems_ref)
          end
        when "ExtManagementSystem"
          source_scope = ExtManagementSystem.where(:id => tenant.source_id)
          if source_scope.exists?
            tenant.update_attributes(:ems_ref => source_scope.first.guid)
          end
        end
      end
    end
  end

  def down
    say_with_time("Nullifying Tenant#ems_ref") do
      Tenant.where.not(:source_id => nil).where(:source_type => %w[CloudTenant ExtManagementSystem]).update_all(:ems_ref => nil)
    end
  end
end
