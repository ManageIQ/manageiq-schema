require_migration

class RemoveVimStringsFromNotifications
  class NotificationType < ActiveRecord::Base
  end
end

describe RemoveVimStringsFromNotifications do
  let(:notification_stub)      { migration_stub(:Notification) }
  let(:notification_type_stub) { migration_stub(:NotificationType) }

  migration_context :up do
    it "converts VimStrings to Strings" do
      options = <<~OPTIONS
        ---
        :error: !ruby/string:VimString
        str: Another task is already in progress.
        xsiType: :SOAP::SOAPString
        vimType:
        :snapshot_op: remove
        :subject: sapm-db2a
      OPTIONS

      notification_type = notification_type_stub.find_or_create_by!(:name => "vm_snapshot_failure")
      notification = notification_stub.create!(
        :notification_type_id => notification_type.id,
        :options           => options
      )

      migrate

      options = YAML.load(notification.reload.options)
      expect(options[:error].class).to eq(String)
    end
  end

  migration_context :down do
    it "restores String to VimString" do
      options = <<~OPTIONS
        ---
        :error: !ruby/string:String
        str: Another task is already in progress.
        xsiType: :SOAP::SOAPString
        vimType:
        :snapshot_op: remove
        :subject: sapm-db2a
      OPTIONS

      notification_type = notification_type_stub.find_or_create_by!(:name => "vm_snapshot_failure")
      notification = notification_stub.create!(
        :notification_type_id => notification_type.id,
        :options           => options
      )

      migrate

      options = notification.reload.options
      expect(options).to include("ruby/string:VimString")
    end
  end
end
