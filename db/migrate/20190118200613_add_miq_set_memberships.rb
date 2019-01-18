class AddMiqSetMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :miq_set_memberships do |t|
      t.belongs_to :member, :polymorphic => true, :type => :bigint
      t.belongs_to :miq_set, :type => :bigint

      t.timestamps
    end
  end
end
