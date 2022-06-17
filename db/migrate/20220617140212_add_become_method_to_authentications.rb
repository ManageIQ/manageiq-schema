class AddBecomeMethodToAuthentications < ActiveRecord::Migration[6.0]
  def change
    add_column :authentications, :become_method, :string
  end
end
