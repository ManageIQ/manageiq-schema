class CreateContainerQuotaScopes < ActiveRecord::Migration[5.0]
  def change
    create_table :container_quota_scopes do |t|
      t.bigint :container_quota_id
      t.string :scope
      t.timestamps
      t.datetime :deleted_on
    end
  end
end
