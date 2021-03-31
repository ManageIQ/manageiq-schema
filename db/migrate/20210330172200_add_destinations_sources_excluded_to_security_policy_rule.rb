class AddDestinationsSourcesExcludedToSecurityPolicyRule < ActiveRecord::Migration[6.0]
  def change
    add_column :security_policy_rules, :sources_excluded, :boolean
    add_column :security_policy_rules, :destinations_excluded, :boolean
  end
end
