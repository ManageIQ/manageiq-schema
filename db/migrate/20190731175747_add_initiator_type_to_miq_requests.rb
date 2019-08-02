class AddInitiatorTypeToMiqRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :miq_requests, :initiated_by, :string
  end
end
