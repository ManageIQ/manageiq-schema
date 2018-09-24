class RenameUserMaintenanceZoneRecord < ActiveRecord::Migration[5.0]
  class UniqueWithinRegionValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return if value.nil?
      match_case = options.key?(:match_case) ? options[:match_case] : true
      record_base_class = record.class.base_class
      field_matches =
        if match_case
          record_base_class.where(attribute => value)
        else
          record_base_class.where(record_base_class.arel_attribute(attribute).lower.eq(value.downcase))
        end
      unless field_matches.in_region(record.region_id).where.not(:id => record.id).empty?
        record.errors.add(attribute, "is not unique within region #{record.region_id}")
      end
    end
  end

  class Zone < ActiveRecord::Base
    include ActiveRecord::IdRegions

    validates_presence_of :name
    validates :name, "rename_user_maintenance_zone_record/unique_within_region" => true

    MAINTENANCE_ZONE_NAME = "__maintenance__".freeze
  end

  class Job < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :miq_task, :dependent => :delete
    after_update_commit :update_linked_task

    def update_linked_task
      miq_task&.update_attributes!(:zone => zone)
    end
  end

  class MiqTask < ActiveRecord::Base
    has_one :job, :dependent => :destroy
    has_one :miq_queue
  end

  class MiqQueue < ActiveRecord::Base
    belongs_to :miq_task
  end

  def up
    say_with_time("Renaming user-defined Maintenance Zone") do
      zone = Zone.in_my_region.find_by(:name => Zone::MAINTENANCE_ZONE_NAME)
      if zone.present?
        # STEP 1 - rename zone
        zone.name = "#{zone.name}_#{Zone.my_region_number}"
        if zone.save
          # STEP 2 - rename string associations
          rename_string_associations(Zone::MAINTENANCE_ZONE_NAME, zone.name)
        else
          raise "Zone '#{Zone::MAINTENANCE_ZONE_NAME}' cannot be renamed to #{zone.name}. Reason: #{zone.errors.messages.inspect}"
        end
      end
    end
  end

  def down
    say_with_time("Renaming user-defined Maintenance Zone") do
      Zone.in_my_region.where(:name    => Zone::MAINTENANCE_ZONE_NAME,
                              :visible => false).destroy_all

      user_zone_name = "#{Zone::MAINTENANCE_ZONE_NAME}_#{Zone.my_region_number}"
      orig = Zone.in_my_region.find_by(:name => user_zone_name)
      if orig.present?
        # STEP 1 - rename user's zone back
        orig.name = Zone::MAINTENANCE_ZONE_NAME
        if orig.save
          # STEP 2 - rename string associations
          rename_string_associations(user_zone_name, Zone::MAINTENANCE_ZONE_NAME)
        else
          raise "Zone '#{user_zone_name}' cannot be renamed to #{Zone::MAINTENANCE_ZONE_NAME}. Reason: #{orig.errors.messages.inspect}"
        end
      end
    end
  end

  private

  def rename_string_associations(old_zone_name, new_zone_name)
    [Job, MiqQueue].each do |klass|
      klass.where(:zone => old_zone_name).each do |record|
        record.zone = new_zone_name
        unless record.save
          # This is not critical, migrations can continue
          say("WARN: #{klass.name}'s (id: #{record.id}) zone not renamed. Reason: #{record.errors.messages.inspect}")
        end
      end
    end
  end
end
