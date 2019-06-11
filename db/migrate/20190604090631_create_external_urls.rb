class CreateExternalUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :external_urls, :id => :bigserial do |t|
      t.references :resource, :polymorphic => true, :type => :bigint
      t.string  :url
      t.belongs_to :user, :type => :bigint
    end

    add_index "external_urls", [:resource_id, :resource_type], :name => "external_urls_on_resource_id_and_resource_type"
  end
end
