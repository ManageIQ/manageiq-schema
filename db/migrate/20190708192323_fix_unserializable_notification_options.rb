class FixUnserializableNotificationOptions < ActiveRecord::Migration[5.1]
  class Notification < ActiveRecord::Base
    belongs_to :notification_type, :class_name => "FixUnserializableNotificationOptions::NotificationType"
  end

  class NotificationType < ActiveRecord::Base
  end

  # only used for testing
  class CloudVolume < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    invalid_options_ids = []
    removed_records_ids = []
    Notification.where.not(:options => nil).each do |n|
      begin
        # Options could have no longer available activerecord/activemodel classes from rails 5.0.0 -> 5.0.6, which will raise an ArgumentError on deserialization
        # Fixing these to use 5.0.7+ smaller serialization format without all the private attributes is too hard, especailly since you can only read their YAML strings
        # and make changes as a string, not as a Hash.
        opts = YAML.load(n.options)
      rescue ArgumentError
        invalid_options_ids << n.id
      else
        begin
          opts_subject = opts[:subject]
          opts_subject.reload if opts_subject.respond_to?(:reload)
        rescue ActiveRecord::RecordNotFound
          # Options are readable. Options[:subject] is a AR::Base object but has been deleted.
          removed_records_ids << n.id
        end
      end
    end

    Notification.where(:id => invalid_options_ids).update_all(:options => {:subject => "Unreadable"}.to_yaml)
    Notification.where(:id => removed_records_ids).update_all(:options => {:subject => "Removed"}.to_yaml)
  end
end
