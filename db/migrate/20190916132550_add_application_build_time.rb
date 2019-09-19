class AddApplicationBuildTime < ActiveRecord::Migration[5.0]
  def change
    add_column :guest_applications, :build_time, :timestamp
  end
end
