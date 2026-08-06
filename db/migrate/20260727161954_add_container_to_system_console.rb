class AddContainerToSystemConsole < ActiveRecord::Migration[8.0]
  def change
    add_reference :system_consoles, :container, foreign_key: true
  end
end
