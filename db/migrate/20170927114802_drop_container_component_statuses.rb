class DropContainerComponentStatuses < ActiveRecord::Migration[5.0]
  def up
    drop_table :container_component_statuses
  end

  def down
    create_table :container_component_statuses do |t|
      t.belongs_to :ems, :type => :bigint
      t.string     :name
      t.string     :condition
      t.string     :status
      t.string     :message
      t.string     :error
    end
  end
end
