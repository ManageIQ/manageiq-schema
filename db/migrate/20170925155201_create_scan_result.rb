class CreateScanResult < ActiveRecord::Migration[5.0]
  def change
    create_table :scan_results do |t|
      t.string :scan_status
      t.string :scan_result_message
      t.string :scan_type
      t.belongs_to :resource, :polymorphic => true, :type => :bigint
    end
  end
end
