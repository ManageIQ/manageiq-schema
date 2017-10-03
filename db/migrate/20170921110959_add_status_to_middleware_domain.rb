class AddStatusToMiddlewareDomain < ActiveRecord::Migration[5.0]
  class MiddlewareDomain < ActiveRecord::Base
  end

  def change
    add_column :middleware_domains, :status, :text
  end
end
