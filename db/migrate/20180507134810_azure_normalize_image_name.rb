class AzureNormalizeImageName < ActiveRecord::Migration[5.0]
  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'
  end

  def up
    say_with_time("Updating Azure template name") do
      VmOrTemplate.where("type = ? and uid_ems like ?", "ManageIQ::Providers::Azure::CloudManager::Template", "http%")
        .update_all("name = regexp_replace(name, '^./', '')")
    end
  end

  def down
    say_with_time("Reverting Azure template name") do
      VmOrTemplate.where("type = ? and uid_ems like ?", "ManageIQ::Providers::Azure::CloudManager::Template", "http%")
        .update_all("name = './' || name")
    end
  end
end
