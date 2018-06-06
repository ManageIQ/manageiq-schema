class AddTitleCvesToOpenscapRuleResults < ActiveRecord::Migration[5.0]
  def change
    add_column :openscap_rule_results, :title, :string
    add_column :openscap_rule_results, :cves, :string
  end
end
