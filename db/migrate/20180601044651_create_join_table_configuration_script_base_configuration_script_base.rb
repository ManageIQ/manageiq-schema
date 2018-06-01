class CreateJoinTableConfigurationScriptBaseConfigurationScriptBase < ActiveRecord::Migration[5.0]
  def change
    create_table :configuration_script_base_configuration_script_bases do |t|
      t.bigint  :parent_id
      t.bigint  :child_id
      t.text    :conditions
      t.index   :parent_id, :name => 'index_parent_configuration_script_base_id'
    end
  end
end
