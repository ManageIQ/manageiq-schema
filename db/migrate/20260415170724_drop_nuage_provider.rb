class DropNuageProvider < ActiveRecord::Migration[8.0]
  class CloudNetwork < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudSubnet < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class CloudTenant < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class FloatingIp < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class NetworkPort < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class NetworkRouter < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  class SecurityGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Deleting SCVMM Provider") do
      ems_class = "ManageIQ::Providers::Nuage::NetworkManager"

      CloudNetwork.in_my_region.where(:type => ["#{ems_class}::CloudNetwork", "#{ems_class}::CloudNetwork::Floating"]).delete_all
      CloudSubnet.in_my_region.where(:type => ["#{ems_class}::CloudSubnet", "#{ems_class}::CloudSubnet::L2", "#{ems_class}::CloudSubnet::L3"]).delete_all
      CloudTenant.in_my_region.where(:type => "#{ems_class}::CloudTenant").delete_all
      FloatingIp.in_my_region.where(:type => "#{ems_class}::FloatingIp").delete_all
      NetworkPort.in_my_region.where(:type => ["#{ems_class}::NetworkPort", "#{ems_class}::NetworkPort::Bridge", "#{ems_class}::NetworkPort::Container", "#{ems_class}::NetworkPort::Host", "#{ems_class}::NetworkPort::Vm"]).delete_all
      NetworkRouter.in_my_region.where(:type => "#{ems_class}::NetworkRouter").delete_all
      SecurityGroup.in_my_region.where(:type => "#{ems_class}::SecurityGroup").delete_all
      ExtManagementSystem.in_my_region.where(:type => ems_class).delete_all
    end
  end
end
