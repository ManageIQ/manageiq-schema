class AddContainerGroupToSystemConsole < ActiveRecord::Migration[8.0]
  def change
    add_reference :system_consoles, :container_group, :type => :bigint, :index => true
  end
end
