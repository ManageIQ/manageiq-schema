class AddResourceToOpenScapResult < ActiveRecord::Migration[5.0]
  def change
    add_column :openscap_results, :resource_id,   :bigint
    add_column :openscap_results, :resource_type, :string
  end
end
