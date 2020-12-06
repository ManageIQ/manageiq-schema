class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.string :ems_ref
      # t.references :physical_storage, :type => :bigint, :index => true
      # t.references :physical_storage_consumer, :type => :bigint, :index => true
      t.belongs_to :owner, :polymorphic => true, :type => :bigint
      t.references :port, polymorphic: true, :index => true
    end
  end
end
