class RemoveInvalidServerHostnames < ActiveRecord::Migration[5.0]
  class MiqServer < ActiveRecord::Base; end
  def up
    MiqServer.where.not(:hostname => nil).find_each do |server|
      server.update_attributes(:hostname => nil) unless server.hostname.hostname?
    end
  end
end
