class AddEmsExtensions < ActiveRecord::Migration[5.0]
  def change
    create_table :ems_extensions, :id => :bigserial, :force => :cascade do |t|
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system

      t.string :ems_ref
      t.string :key
      t.string :company
      t.string :label
      t.string :summary
      t.string :version

      t.timestamps
    end
  end
end
