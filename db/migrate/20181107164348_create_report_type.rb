class CreateReportType < ActiveRecord::Migration[5.0]
  def change
    create_table :report_types do |t|
      t.string :name
      t.belongs_to :resource, :polymorphic => true, :type => :bigint
      t.timestamps
    end

    add_index :report_types, [:resource_id, :resource_type]
  end
end
