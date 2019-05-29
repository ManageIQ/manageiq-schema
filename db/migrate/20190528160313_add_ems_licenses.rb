class AddEmsLicenses < ActiveRecord::Migration[5.0]
  def change
    create_table :ems_licenses, :id => :bigserial, :force => :cascade do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system

      t.string  :ems_ref
      t.string  :name
      t.string  :license_key
      t.string  :license_edition
      t.integer :total_licenses
      t.integer :used_licenses

      t.timestamps
    end
  end
end
