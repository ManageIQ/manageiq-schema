require_migration

describe FixUnserializableNotificationOptions do
  let(:notification_stub)      { migration_stub(:Notification) }
  let(:notification_type_stub) { migration_stub(:NotificationType) }

  migration_context :up do
    it "fixes options[:subject] classes that don't exist" do
      notification1 = notification_stub.create!(:notification_type => notification_type_stub.create!)
      notification1.update(
        :options =>
          <<~OPTIONS
            ---
            :subject: !ruby/object:NonExistingCloudVolume
              concise_attributes:
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: id
                value_before_type_cast: 3
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: type
                value_before_type_cast: NonExistingCloudVolume
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: name
                value_before_type_cast: MyCloudVolume
              new_record: false
              active_record_yaml_version: 2
          OPTIONS
      )

      expect { YAML.load(notification1.reload.options) }.to raise_error(ArgumentError)

      migrate

      expect(YAML.load(notification1.reload.options)[:subject]).to eq("Unreadable")
    end

    it "Sets options[:subject] where the record no longer exists" do
      notification1 = notification_stub.create!(:notification_type => notification_type_stub.create!)
      notification1.update(
        :options =>
          <<~OPTIONS
            ---
            :subject: !ruby/object:FixUnserializableNotificationOptions::CloudVolume
              concise_attributes:
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: id
                value_before_type_cast: 3
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: type
                value_before_type_cast: ManageIQ::Providers::Openstack::CloudManager::CloudVolume
              - !ruby/object:ActiveRecord::Attribute::FromDatabase
                name: name
                value_before_type_cast: MyCloudVolume
              new_record: false
              active_record_yaml_version: 2
          OPTIONS
      )

      expect { YAML.load(notification1.reload.options)[:subject].reload }.to raise_error(ActiveRecord::RecordNotFound)

      migrate

      expect(YAML.load(notification1.reload.options)[:subject]).to eq("Removed")
    end
  end
end
