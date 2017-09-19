class CreateSubnets < ActiveRecord::Migration[5.0]
  def change
    create_table :subnets do |t|
      t.string :ems_ref
      t.string :name
      t.string :cidr
      t.string :type
      t.bigint :lan_id
    end
  end
end
