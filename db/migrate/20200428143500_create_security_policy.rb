class CreateSecurityPolicy < ActiveRecord::Migration[5.0]
  def change
    create_table :security_policies do |t|
      t.string     :type
      t.string     :name
      t.string     :description
      t.string     :ems_ref
      t.references :ems,               :type => :bigint
      t.references :cloud_tenant,      :type => :bigint
      t.integer    :sequence_number
      t.timestamps
    end

    add_index :security_policies, :type

    create_table :security_policy_rules do |t|
      t.string     :type
      t.string     :name
      t.string     :description
      t.string     :ems_ref
      t.references :ems,               :type => :bigint
      t.references :cloud_tenant,      :type => :bigint
      t.references :security_policy,   :type => :bigint
      t.integer    :sequence_number
      t.string     :status
      t.string     :action
      t.string     :direction
      t.string     :ip_protocol
      t.timestamps
    end

    add_index :security_policy_rules, :type

    create_table :security_policy_rule_destination_security_groups, :id => true do |t|
      t.references :security_policy_rule, :type => :bigint, :index => {:name => :index_sec_policy_rule_dest_groups_on_security_policy_rule_id}
      t.references :security_group,       :type => :bigint, :index => {:name => :index_sec_policy_rule_dest_groups_on_security_group_rule_id}
      t.timestamps
    end

    add_index :security_policy_rule_destination_security_groups, [:security_policy_rule_id, :security_group_id], :unique => true, :name => "index_sec_policy_rule_dest_groups"

    create_table :security_policy_rule_source_security_groups, :id => true do |t|
      t.references :security_policy_rule, :type => :bigint, :index => {:name => :index_sec_policy_rule_src_groups_on_security_policy_rule_id}
      t.references :security_group,       :type => :bigint, :index => {:name => :index_sec_policy_rule_src_groups_on_security_group_rule_id}
      t.timestamps
    end

    add_index :security_policy_rule_source_security_groups, [:security_policy_rule_id, :security_group_id], :unique => true, :name => "index_sec_policy_rule_src_groups"

    create_table :security_policy_rule_network_services, :id => true do |t|
      t.references :security_policy_rule, :type => :bigint, :index => {:name => :index_sec_policy_rule_services_on_security_policy_rule_id}
      t.references :network_service,      :type => :bigint, :index => {:name => :index_sec_policy_rule_services_on_network_service_id}
      t.timestamps
    end

    add_index :security_policy_rule_network_services, [:security_policy_rule_id, :network_service_id], :unique => true, :name => "index_sec_policy_rule_services"
  end
end
