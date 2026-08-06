class AddContainerToSystemConsole < ActiveRecord::Migration[8.0]
  def change
    add_reference :system_consoles, :container, :type => :bigint, :index => true
  end
end
