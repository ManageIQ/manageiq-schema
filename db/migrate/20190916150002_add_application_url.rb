class AddApplicationUrl < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_applications, :url, :string
  end
end
