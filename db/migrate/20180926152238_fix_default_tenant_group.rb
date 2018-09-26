class FixDefaultTenantGroup < ActiveRecord::Migration[5.0]
  class Tenant < ActiveRecord::Base
    belongs_to :default_miq_group, :class_name => "::FixDefaultTenantGroup::MiqGroup"

    def add_default_miq_group
      tenant_group = ::FixDefaultTenantGroup::MiqGroup.create_tenant_group(self)
      update_attributes!(:default_miq_group_id => tenant_group.id)
    end

    def root?
      ancestry.nil?
    end
  end

  class MiqUserRole < ActiveRecord::Base
    DEFAULT_TENANT_ROLE_NAME = "EvmRole-tenant_administrator".freeze

    # if there is no role, that is ok
    # MiqGroup.seed will populate

    def self.default_tenant_role
      @default_role ||= find_by(:name => DEFAULT_TENANT_ROLE_NAME)
    end
  end

  class MiqGroup < ActiveRecord::Base
    TENANT_GROUP = "tenant".freeze
    USER_GROUP   = "user".freeze

    def tenant_group?
      group_type == TENANT_GROUP
    end

    def self.create_tenant_group(tenant)
      role = ::FixDefaultTenantGroup::MiqUserRole.default_tenant_role
      create_with(
        :description      => "Tenant #{tenant.name} #{tenant.id} access",
        :sequence         => 1,
        :guid             => SecureRandom.uuid,
        :miq_user_role_id => role.try(:id)
      ).find_or_create_by!(
        :tenant_id  => tenant.id,
        :group_type => TENANT_GROUP,
      )
    end
  end

  def up
    say_with_time "adding default tenant groups" do
      Tenant.find_each do |t|
        next if t.default_miq_group&.tenant_group?
        t.default_miq_group_id = nil
        t.add_default_miq_group
      end
    end
  end
end
