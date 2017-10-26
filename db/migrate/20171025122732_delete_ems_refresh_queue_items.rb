class DeleteEmsRefreshQueueItems < ActiveRecord::Migration[5.0]
  class MiqQueue < ActiveRecord::Base; end

  def up
    say_with_time('Delete EmsRefresh.refresh Queue Items') do
      MiqQueue.where(:class_name => 'EmsRefresh', :method_name => 'refresh').delete_all
    end
  end
end
