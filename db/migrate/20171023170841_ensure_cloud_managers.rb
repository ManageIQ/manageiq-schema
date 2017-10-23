class EnsureCloudManagers < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI

    def ensure_managers
      ensure_manager("#{name} Network Manager",     "ManageIQ::Providers::Amazon::NetworkManager")
      ensure_manager("#{name} EBS Storage Manager", "ManageIQ::Providers::Amazon::StorageManager::Ebs")
    end

    def ensure_manager(manager_name, manager_type)
      self.class.create_with(
        :name            => manager_name,
        :zone_id         => zone_id,
        :provider_region => provider_region
      ).find_or_create_by!(
        :parent_ems_id => id,
        :type          => manager_type
      )
    end
  end

  def up
    say_with_time("Ensuring other managers for all Amazon CloudManagers") do
      ExtManagementSystem.where(:type => "ManageIQ::Providers::Amazon::CloudManager").each(&:ensure_managers)
    end
  end
end
