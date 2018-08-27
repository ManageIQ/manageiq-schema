class AddLinkToNotificationTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :notification_types, :link_to, :string
  end
end
