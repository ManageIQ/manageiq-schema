class AddParentRelationToMiqRequests < ActiveRecord::Migration[6.0]
  def change
    add_reference :miq_requests, :parent, :type => :bigint
  end
end
