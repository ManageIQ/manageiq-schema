class AddPayloadCredentialsConfigurationScripts < ActiveRecord::Migration[6.1]
  def change
    change_table :configuration_scripts do |t|
      t.string     :run_by_userid
      t.string     :payload
      t.string     :payload_type
      t.jsonb      :credentials
      t.jsonb      :context
      t.jsonb      :output
      t.string     :status
      t.references :miq_task
    end
  end
end
