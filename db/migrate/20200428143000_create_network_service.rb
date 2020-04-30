class CreateNetworkService < ActiveRecord::Migration[5.0]
  def change
    create_table :network_services do |t|
      t.string     :type
      t.string     :name
      t.string     :description
      t.string     :ems_ref
      t.references :ems,               :type => :bigint
      t.references :cloud_tenant,      :type => :bigint
      t.timestamps
    end

    create_table :network_service_entries do |t|
      t.string     :type
      t.string     :name
      t.string     :description
      t.string     :ems_ref
      t.references :ems,               :type => :bigint
      t.references :network_service,   :type => :bigint
      t.string     :protocol
      t.string     :source_ports
      t.string     :destination_ports
      t.timestamps
    end

    add_index :network_services,        :type
    add_index :network_service_entries, :type
  end
end
