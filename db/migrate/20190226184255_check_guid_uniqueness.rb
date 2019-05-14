class CheckGuidUniqueness < ActiveRecord::Migration[5.0]
  # several models already have unique constraints on index so we don't have to deal with them in this migration:
  # vm, miq_set, scan_item, miq_worker, miq_server, miq_event_definition, miq_action, lifecycle event, job, host, ems

  class AutomateWorkspace < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true, :presence => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqAeWorkspace < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqPolicy < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqRegion < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class MiqWidget < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class Service < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  class ServiceTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :guid, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    [AutomateWorkspace, MiqAeWorkspace, MiqPolicy, MiqRegion, MiqWidget, Service, ServiceTemplate].each do |thing|
      say_with_time("Checking #{thing} for guid uniqueness") do
        thing.in_my_region.where(:guid => thing.in_my_region.select(:guid).group(:guid).having("count(*) > 1").pluck(:guid)).order(:id).drop(1).each { |obj| obj.update_attributes!(:guid => SecureRandom.uuid) }
      end
    end
  end
end
