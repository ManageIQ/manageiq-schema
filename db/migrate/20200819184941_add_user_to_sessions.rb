class AddUserToSessions < ActiveRecord::Migration[5.2]
  def change
    add_reference :sessions, :user
  end
end
