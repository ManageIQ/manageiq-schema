class MigrateEmsRefObjToEmsRefType < ActiveRecord::Migration[5.1]
  class EmsCluster < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class EmsFolder < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class ResourcePool < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class Snapshot < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class Storage < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    include ActiveRecord::IdRegions
  end
  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    self.table_name         = "vms"
    include ActiveRecord::IdRegions
  end

  MODELS_WITH_EMS_REF_OBJ = [EmsCluster, EmsFolder, Host, ResourcePool, Snapshot, Storage, VmOrTemplate].freeze

  def up
    MODELS_WITH_EMS_REF_OBJ.each do |klass|
      say_with_time("Converting ems_ref_obj to ems_ref_type for #{klass.name}") do
        klass.in_my_region.where("ems_ref_obj LIKE '%VimString%'").find_each do |obj|
          ems_ref_type = parse_ems_ref_obj(obj.ems_ref_obj)["vimType"]
          obj.update!(:ems_ref_type => ems_ref_type)
        end
      end
    end
  end

  def down
    MODELS_WITH_EMS_REF_OBJ.each do |klass|
      say_with_time("Converting ems_ref_type to ems_ref_obj for #{klass.name}") do
        # Skip any records that have ems_ref_obj set already and don't have ems_ref_type set
        query_params = {:ems_ref_type => nil, :ems_ref_obj => nil}

        # Skip cloud VMs which never had ems_ref_obj set
        query_params[:cloud] = [nil, false] if klass == VmOrTemplate

        klass.in_my_region.where(query_params).find_each do |obj|
          obj.update!(:ems_ref_obj => "--- #{obj.ems_ref}\n")
        end

        klass.in_my_region.where.not(:ems_ref_type => nil).find_each do |obj|
          ems_ref_obj = <<~EMS_REF_OBJ
            --- !ruby/string:VimString
            str: #{obj.ems_ref}
            xsiType: :ManagedObjectReference
            vimType: :#{obj.ems_ref_type}
          EMS_REF_OBJ

          obj.update!(:ems_ref_obj => ems_ref_obj)
        end
      end
    end
  end

  private

  def parse_ems_ref_obj(ems_ref_obj)
    Hash[
      ems_ref_obj.split("\n")[1..-1].map do |o|
        key, val = o.split(": ")

        # Convert symbol values from ":Type" to :Type
        val = val[1..-1].to_sym if val[0] == ':'

        [key, val]
      end.compact
    ]
  end
end
