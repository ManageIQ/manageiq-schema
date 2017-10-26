class MoveEmsRefreshArgsToData < ActiveRecord::Migration[5.0]
  class MiqQueue < ActiveRecord::Base
    serialize :args, Array
  end

  def up
    say_with_time('Move MiqQueue refresh args to data') do
      MiqQueue.where(:class_name => 'EmsRefresh', :method_name => 'refresh').each do |queue_item|
        begin
          targets = queue_item.args.first
          data = Marshal.dump(targets) unless targets.nil?

          queue_item.update_attributes(:msg_data => data, :args => [])
        rescue
          # If Marshal.load fails we want to delete the queue item
          queue_item.delete
        end
      end
    end
  end

  def down
    say_with_time('Move MiqQueue refresh data to args') do
      MiqQueue.where(:class_name => 'EmsRefresh', :method_name => 'refresh').each do |queue_item|
        begin
          args = queue_item.msg_data && Marshal.load(queue_item.msg_data)

          queue_item.update_attributes(:args => args, :msg_data => nil)
        rescue
          # If Marshal.load fails we want to delete the queue item
          queue_item.delete
        end
      end
    end
  end
end
