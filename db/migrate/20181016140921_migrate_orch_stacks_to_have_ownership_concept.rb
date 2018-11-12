class MigrateOrchStacksToHaveOwnershipConcept < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    belongs_to :tenant, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::Tenant"

    def tenant_identity
      User.super_admin.tap { |u| u.current_group = tenant.default_miq_group }
    end
  end

  class Service < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    belongs_to :evm_owner, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::User"

    def root
      ancestry.present? ? self.class.find(ancestry.split("/").first) : self
    end
    alias root_service root

    def tenant_identity
      user = evm_owner
      if user.nil? || !user.miq_group_ids.include?(miq_group_id)
        user = User.super_admin.tap { |u| u.current_group_id = miq_group_id }
      end
      user
    end
  end

  class MiqGroup < ActiveRecord::Base
    TENANT_GROUP = "tenant".freeze
    self.inheritance_column = :_type_disabled # disable STI

    belongs_to :tenant,     :class_name => "MigrateOrchStacksToHaveOwnershipConcept::Tenant"
    has_one :miq_user_role, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::MiqUserRole"

    def self.create_tenant_group(tenant)
      create_with(
        :description         => "Tenant access",
        :default_tenant_role => MiqUserRole.default_tenant_role
      ).find_or_create_by!(
        :group_type => TENANT_GROUP,
        :tenant_id  => tenant.id,
      )
    end
  end

  class MiqUserRole < ActiveRecord::Base
    DEFAULT_TENANT_ROLE_NAME = "EvmRole-tenant_administrator".freeze
    self.inheritance_column = :_type_disabled # disable STI

    def self.default_tenant_role
      find_by(:name => DEFAULT_TENANT_ROLE_NAME)
    end
  end

  class User < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    has_and_belongs_to_many :miq_groups, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::MiqGroup"
    belongs_to :current_group,           :class_name => "MigrateOrchStacksToHaveOwnershipConcept::MiqGroup"

    include ActiveRecord::IdRegions

    def self.super_admin
      in_my_region.find_by(:userid => "admin")
    end

    def current_tenant
      current_group.tenant
    end
  end

  class ServiceResource < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    belongs_to :service, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::Service"
  end

  class Tenant < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    belongs_to :default_miq_group, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::MiqGroup", :dependent => :destroy
    after_create :create_tenant_group

    def create_tenant_group
      update_attributes!(:default_miq_group => MiqGroup.create_tenant_group(self)) unless default_miq_group_id
      self
    end
  end

  class OrchestrationStack < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    has_many :service_resources, :as => :resource, :class_name => "MigrateOrchStacksToHaveOwnershipConcept::ServiceResource"
    has_many :direct_services, :through => :service_resources, :source => :service
    belongs_to :ext_management_system, :foreign_key => :ems_id

    def root
      ancestry.present? ? self.class.find(ancestry.split("/").first) : self
    end

    def direct_service
      direct_services.first || (root.direct_services.first if root != self)
    end

    def service
      direct_service.try(:root_service) || (root.direct_service.try(:root_service) if root != self)
    end
  end

  def up
    say_with_time("Migrating existing orchestration stacks to have direct owners, groups, tenant") do
      OrchestrationStack.find_each do |stack|
        user = if stack.service.present?
                 stack.service.tenant_identity
               elsif !stack.ems_id.nil?
                 stack.ext_management_system.tenant_identity
               else
                 User.super_admin
               end
        stack.update_attributes(:evm_owner_id => user.id, :tenant_id => user.current_tenant.id, :miq_group_id => user.current_group.id)
      end
    end
  end

  def down
    # blank because the down migration on AddEvmOwnerToOrchestrationStacks covers this
  end
end
