class DropLdapTables < ActiveRecord::Migration[5.0]
  def up
    drop_table :ldap_domains
    drop_table :ldap_groups
    drop_table :ldap_managements
    drop_table :ldap_regions
    drop_table :ldap_servers
    drop_table :ldap_users
  end

  def down
    create_table :ldap_domains do |t|
      t.string   :name
      t.string   :base_dn
      t.string   :user_type
      t.string   :user_suffix
      t.integer  :bind_timeout
      t.integer  :search_timeout
      t.integer  :group_membership_max_depth
      t.boolean  :get_direct_groups
      t.boolean  :follow_referrals
      t.bigint   :ldap_domain_id
      t.datetime :created_at,                 :null => false
      t.datetime :updated_at,                 :null => false
      t.datetime :last_user_sync
      t.datetime :last_group_sync
      t.boolean  :get_user_groups
      t.boolean  :get_roles_from_home_forest
      t.bigint   :ldap_region_id
      t.index [:ldap_region_id], :name => :index_ldap_domains_on_ldap_region_id
    end

    create_table :ldap_groups do |t|
      t.string   :dn
      t.string   :display_name
      t.string   :whencreated
      t.string   :whenchanged
      t.string   :mail
      t.bigint   :ldap_domain_id
      t.datetime :created_at,     :null => false
      t.datetime :updated_at,     :null => false
      t.index [:ldap_domain_id], :name => :index_ldap_groups_on_ldap_domain_id
    end

    create_table :ldap_managements do |t|
      t.bigint :manager_id
      t.bigint :ldap_user_id
    end

    create_table :ldap_regions do |t|
      t.string   :name
      t.string   :description
      t.bigint   :zone_id
      t.datetime :created_at,  :null => false
      t.datetime :updated_at,  :null => false
      t.index [:zone_id], :name => :index_ldap_regions_on_zone_id
    end

    create_table :ldap_servers do |t|
      t.string   :hostname
      t.string   :mode
      t.integer  :port
      t.bigint   :ldap_domain_id
      t.datetime :created_at,     :null => false
      t.datetime :updated_at,     :null => false
      t.index [:ldap_domain_id], :name => :index_ldap_servers_on_ldap_domain_id
    end

    create_table :ldap_users do |t|
      t.string   :dn
      t.string   :first_name
      t.string   :last_name
      t.string   :title
      t.string   :display_name
      t.string   :mail
      t.string   :address
      t.string   :city
      t.string   :state
      t.string   :zip
      t.string   :country
      t.string   :company
      t.string   :department
      t.string   :office
      t.string   :phone
      t.string   :phone_home
      t.string   :phone_mobile
      t.string   :fax
      t.datetime :whencreated
      t.datetime :whenchanged
      t.string   :sid
      t.bigint   :ldap_domain_id
      t.datetime :created_at,       :null => false
      t.datetime :updated_at,       :null => false
      t.string   :sam_account_name
      t.string   :upn
      t.index [:ldap_domain_id], :name => :index_ldap_users_on_ldap_domain_id
    end
  end
end
