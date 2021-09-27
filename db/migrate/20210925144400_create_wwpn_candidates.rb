class CreateWwpnCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :wwpn_candidates do |t|
      # stores WWPN candidate
      t.string :candidate

      t.string :ems_ref
      t.references :ems, :type => :bigint, :index => true, :references => :ext_management_system
      t.references :physical_storage, :type => :bigint, :index => true

      t.timestamps
    end
  end
end
