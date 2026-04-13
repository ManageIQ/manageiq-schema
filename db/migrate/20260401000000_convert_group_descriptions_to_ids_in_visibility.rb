class ConvertGroupDescriptionsToIdsInVisibility < ActiveRecord::Migration[8.0]
  class MiqWidget < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    serialize :visibility, :type => Hash
  end

  class MiqGroup < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Converting MiqWidget group descriptions to IDs") do
      convert_group_descriptions_to_ids_for_model(MiqWidget)
    end
  end

  def down
    say_with_time("Converting MiqWidget group IDs to descriptions") do
      revert_group_ids_to_descriptions_for_model(MiqWidget)
    end
  end

  private

  def convert_group_descriptions_to_ids_for_model(model)
    transform_groups_for_model(model) { |groups, record| build_group_ids(groups, record) }
  end

  def revert_group_ids_to_descriptions_for_model(model)
    transform_groups_for_model(model) { |groups, record| build_group_descriptions(groups, record) }
  end

  def transform_groups_for_model(model)
    model.in_my_region.where.not(:visibility => nil).find_each do |record|
      next unless record.visibility.kind_of?(Hash)

      groups = record.visibility[:groups]
      next if groups.blank? || groups == ["_ALL_"]

      new_groups = yield(groups, record)

      record.visibility = record.visibility.merge(:groups => new_groups)
      record.save!
    end
  end

  def build_group_ids(groups, record)
    valid_ids = []
    invalid_descriptions = []

    groups.each do |group_description_or_id|
      if group_description_or_id.kind_of?(String) && group_description_or_id != "_ALL_"
        group = MiqGroup.in_my_region.where(:description => group_description_or_id).first
        if group
          valid_ids << group.id
        else
          invalid_descriptions << group_description_or_id
        end
      elsif group_description_or_id != "_ALL_"
        # Already an ID
        valid_ids << group_description_or_id
      end
    end

    if invalid_descriptions.any?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} has invalid group descriptions that will be removed: #{invalid_descriptions.join(', ')}"
      say(message, true)
      Rails.logger.warn(message)
    end

    # Return empty array if no valid groups found
    if valid_ids.empty?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} had no valid groups, visibility will be empty. Administrator can assign correct groups."
      say(message, true)
      Rails.logger.warn(message)
    end

    valid_ids
  end

  def build_group_descriptions(groups, record)
    valid_descriptions = []
    invalid_ids = []

    groups.each do |group_id|
      if group_id.kind_of?(Integer) || (group_id.kind_of?(String) && group_id.match?(/^\d+$/))
        group = MiqGroup.in_my_region.where(:id => group_id.to_i).first
        if group
          valid_descriptions << group.description
        else
          invalid_ids << group_id
        end
      else
        # Already a description or special value
        valid_descriptions << group_id unless group_id == "_ALL_"
      end
    end

    if invalid_ids.any?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} has invalid group IDs that will be removed: #{invalid_ids.join(', ')}"
      say(message, true)
      Rails.logger.warn(message)
    end

    # Return empty array if no valid groups found
    if valid_descriptions.empty?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} had no valid groups, visibility will be empty. Administrator can assign correct groups."
      say(message, true)
      Rails.logger.warn(message)
    end

    valid_descriptions
  end

  def record_identifier(record)
    name = record.try(:name) || record.try(:description) || record.try(:title)
    name_part = name ? " (#{name})" : ""
    "#{record.class.name} ID #{record.id}#{name_part}"
  end
end
