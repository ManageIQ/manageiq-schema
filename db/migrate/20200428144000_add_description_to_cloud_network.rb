# rake db:migrate:down VERSION=20200428000003
# rake db:migrate:up VERSION=20200428000003
class AddDescriptionToCloudNetwork < ActiveRecord::Migration[5.1]
  def change
    add_column :cloud_networks, :description, :string
  end
end
