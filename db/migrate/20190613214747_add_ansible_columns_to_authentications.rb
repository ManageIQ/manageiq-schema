class AddAnsibleColumnsToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :become_username, :string
    add_column :authentications, :become_password, :string
    add_column :authentications, :auth_key_password, :string
  end
end
