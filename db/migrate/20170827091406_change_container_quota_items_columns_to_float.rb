class ChangeContainerQuotaItemsColumnsToFloat < ActiveRecord::Migration[5.0]
  class ContainerQuotaItem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    add_column :container_quota_items, :quota_desired_float, :float
    add_column :container_quota_items, :quota_enforced_float, :float
    add_column :container_quota_items, :quota_observed_float, :float

    ContainerQuotaItem.find_each do |item|
      item.quota_desired_float = numeric_quantity(item.quota_desired)
      item.quota_enforced_float = numeric_quantity(item.quota_enforced)
      item.quota_observed_float = numeric_quantity(item.quota_observed)
      item.save
    end

    remove_column :container_quota_items, :quota_desired
    remove_column :container_quota_items, :quota_enforced
    remove_column :container_quota_items, :quota_observed

    rename_column :container_quota_items, :quota_desired_float, :quota_desired
    rename_column :container_quota_items, :quota_enforced_float, :quota_enforced
    rename_column :container_quota_items, :quota_observed_float, :quota_observed
  end

  def down
    add_column :container_quota_items, :quota_desired_string, :string
    add_column :container_quota_items, :quota_enforced_string, :string
    add_column :container_quota_items, :quota_observed_string, :string

    ContainerQuotaItem.find_each do |item|
      item.quota_desired_string = string_quantity(item.quota_desired)
      item.quota_enforced_string = string_quantity(item.quota_enforced)
      item.quota_observed_string = string_quantity(item.quota_observed)
      item.save
    end

    remove_column :container_quota_items, :quota_desired
    remove_column :container_quota_items, :quota_enforced
    remove_column :container_quota_items, :quota_observed

    rename_column :container_quota_items, :quota_desired_string, :quota_desired
    rename_column :container_quota_items, :quota_enforced_string, :quota_enforced
    rename_column :container_quota_items, :quota_observed_string, :quota_observed
  end

  def numeric_quantity(resource) # parse a string with a suffix into a int\float
    return nil if resource.nil?

    begin
      resource.iec_60027_2_to_i
    rescue
      resource.decimal_si_to_f
    end
  end

  def string_quantity(resource)
    return nil if resource.nil?

    val = resource == resource.to_i ? resource.to_i : resource
    val.to_s
  end
end
