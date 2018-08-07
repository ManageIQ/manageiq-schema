class CreateTaskForEachJobAndTransferAttributes < ActiveRecord::Migration[5.0]
  class Job < ActiveRecord::Base
    belongs_to :miq_task, :class_name =>'CreateTaskForEachJobAndTransferAttributes::MiqTask'
    self.inheritance_column = :_type_disabled
  end

  class MiqTask < ActiveRecord::Base
    has_one :job, :class_name => 'CreateTaskForEachJobAndTransferAttributes::Job'
  end

  class LogFile < ActiveRecord::Base
  end

  class BinaryBlob < ActiveRecord::Base
  end

  def up
    purge_date = 7.days.ago.utc
    say_with_time("Deleting finished jobs older than 7 days") do
      Job.where("updated_on < ?", purge_date).where("state = 'finished'").delete_all
    end

    old_finished_tasks = MiqTask.where("updated_on < ?", purge_date).where("state = 'Finished'")
    say_with_time("Deleting logs linked to finished tasks older than 7 days") do
      LogFile.where(:miq_task_id => old_finished_tasks.select(:id)).delete_all
    end
    say_with_time("Deleting BinaryBlobs linked to finished tasks older than 7 days") do
      BinaryBlob.where(:resource_type => 'MiqTask', :resource_id => old_finished_tasks.select(:id)).delete_all
    end
    say_with_time("Deleting finished tasks older than 7 days") do
      old_finished_tasks.delete_all
    end

    say_with_time("Creating tasks associated with jobs") do
      Job.find_each do |job|
        job.create_miq_task(:status        => job.status.try(:capitalize),
                            :name          => job.name,
                            :message       => job.message,
                            :state         => job.state.try(:capitalize),
                            :userid        => job.userid,
                            :miq_server_id => job.miq_server_id,
                            :context_data  => job.context,
                            :started_on    => job.started_on,
                            :zone          => job.zone)
      end
    end
  end

  def down
    say_with_time("Deleting all tasks which have job") do
      MiqTask.where("id in (select miq_task_id from jobs)").delete_all
      Job.update_all(:miq_task_id => nil)
    end
  end
end
