class ConvertRoleNamesToIdsInVisibility < ActiveRecord::Migration[8.0]
  class CustomButton < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    serialize :visibility, :type => Hash
  end

  class MiqWidget < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
    serialize :visibility, :type => Hash
  end

  class MiqUserRole < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Converting CustomButton role names to IDs") do
      convert_role_names_to_ids_for_model(CustomButton)
    end

    say_with_time("Converting MiqWidget role names to IDs") do
      convert_role_names_to_ids_for_model(MiqWidget)
    end
  end

  def down
    say_with_time("Converting CustomButton role IDs to names") do
      revert_role_ids_to_names_for_model(CustomButton)
    end

    say_with_time("Converting MiqWidget role IDs to names") do
      revert_role_ids_to_names_for_model(MiqWidget)
    end
  end

  private

  def convert_role_names_to_ids_for_model(model)
    transform_roles_for_model(model) { |roles, record| build_role_ids(roles, record) }
  end

  def revert_role_ids_to_names_for_model(model)
    transform_roles_for_model(model) { |roles, record| build_role_names(roles, record) }
  end

  def transform_roles_for_model(model)
    model.in_my_region.where.not(:visibility => nil).find_each do |record|
      next unless record.visibility.kind_of?(Hash)

      roles = record.visibility[:roles]
      next if roles.blank? || roles == ["_ALL_"]

      new_roles = yield(roles, record)

      record.visibility = record.visibility.merge(:roles => new_roles)
      record.save!
    end
  end

  def build_role_ids(roles, record)
    valid_ids = []
    invalid_names = []

    roles.each do |role_name_or_id|
      if role_name_or_id.kind_of?(String) && role_name_or_id != "_ALL_"
        role = MiqUserRole.in_my_region.where(:name => role_name_or_id).first
        if role
          valid_ids << role.id
        else
          invalid_names << role_name_or_id
        end
      elsif role_name_or_id != "_ALL_"
        # Already an ID
        valid_ids << role_name_or_id
      end
    end

    if invalid_names.any?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} has invalid role names that will be removed: #{invalid_names.join(', ')}"
      say(message, true)
      Rails.logger.warn(message)
    end

    # Return empty array if no valid roles found
    if valid_ids.empty?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} had no valid roles, visibility will be empty. Administrator can assign correct roles."
      say(message, true)
      Rails.logger.warn(message)
    end

    valid_ids
  end

  def build_role_names(roles, record)
    valid_names = []
    invalid_ids = []

    roles.each do |role_id|
      if role_id.kind_of?(Integer) || (role_id.kind_of?(String) && role_id.match?(/^\d+$/))
        role = MiqUserRole.in_my_region.where(:id => role_id.to_i).first
        if role
          valid_names << role.name
        else
          invalid_ids << role_id
        end
      else
        # Already a name or special value
        valid_names << role_id unless role_id == "_ALL_"
      end
    end

    if invalid_ids.any?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} has invalid role IDs that will be removed: #{invalid_ids.join(', ')}"
      say(message, true)
      Rails.logger.warn(message)
    end

    # Return empty array if no valid roles found
    if valid_names.empty?
      record_info = record_identifier(record)
      message = "WARNING: #{record_info} had no valid roles, visibility will be empty. Administrator can assign correct roles."
      say(message, true)
      Rails.logger.warn(message)
    end

    valid_names
  end

  def record_identifier(record)
    name = record.try(:name) || record.try(:description)
    name_part = name ? " (#{name})" : ""
    "#{record.class.name} ID #{record.id}#{name_part}"
  end
end
