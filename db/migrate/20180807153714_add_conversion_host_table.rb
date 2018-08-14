class AddConversionHostTable < ActiveRecord::Migration[5.0]
  def change
    create_table :conversion_hosts do |t|
      t.string     :name
      t.string     :address
      t.string     :type
      t.references :resource, :type => :bigint, :polymorphic => true
      t.string     :version
      t.integer    :max_concurrent_tasks
      t.boolean    :vddk_transport_supported
      t.boolean    :ssh_transport_supported
      t.timestamps
      t.index %w(resource_id resource_type)
    end
  end
end
