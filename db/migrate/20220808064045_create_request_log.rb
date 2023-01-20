class CreateRequestLog < ActiveRecord::Migration[6.0]
  def change
    create_table :request_logs do |t|
      t.string :message
      t.string :severity
      t.references :resource, :type => :bigint
      t.timestamps
    end
  end
end
