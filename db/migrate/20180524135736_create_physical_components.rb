class CreatePhysicalComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :physical_components do |t|
      t.belongs_to :component, :type => :bigint, :polymorphic => true
      t.timestamps :null => true
      t.index      %i(component_id component_type)
    end
  end
end
