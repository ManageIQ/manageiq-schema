class UpdateOpenstackHostsUidEms < ActiveRecord::Migration[5.1]
  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end

  def up
    Host.in_my_region.where(:type => "ManageIQ::Providers::Openstack::InfraManager::Host").where.not(:ems_ref_obj => nil).find_each do |host|
      host.uid_ems = YAML.safe_load(host.ems_ref_obj)
      host.save!
    end
  end

  def down
    Host.in_my_region.where(:type => "ManageIQ::Providers::Openstack::InfraManager::Host").find_each do |host|
      host.ems_ref_obj = YAML.dump(host.uid_ems)
      host.uid_ems     = host.ems_ref
      host.save!
    end
  end
end
