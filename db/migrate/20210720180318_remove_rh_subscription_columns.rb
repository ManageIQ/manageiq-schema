class RemoveRhSubscriptionColumns < ActiveRecord::Migration[6.0]
  def up
    change_table "miq_servers" do |t|
      t.remove "rh_registered"
      t.remove "rh_subscribed"
      t.remove "last_update_check"
      t.remove "updates_available"
      t.remove "upgrade_status"
      t.remove "upgrade_message"
    end

    change_table "miq_databases" do |t|
      t.remove "cfme_version_available"
      t.remove "postgres_update_available"
      t.remove "registration_type"
      t.remove "registration_organization"
      t.remove "registration_server"
      t.remove "registration_http_proxy_server"
      t.remove "registration_organization_display_name"
    end
  end

  def down
    change_table "miq_databases" do |t|
      t.string "cfme_version_available"
      t.boolean "postgres_update_available"
      t.string "registration_type"
      t.string "registration_organization"
      t.string "registration_server"
      t.string "registration_http_proxy_server"
      t.string "registration_organization_display_name"
    end

    change_table "miq_servers" do |t|
      t.boolean "rh_registered"
      t.boolean "rh_subscribed"
      t.string "last_update_check"
      t.boolean "updates_available"
      t.string "upgrade_status"
      t.string "upgrade_message"
    end
  end
end
