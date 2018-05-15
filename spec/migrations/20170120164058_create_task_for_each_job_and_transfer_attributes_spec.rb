require_migration

describe CreateTaskForEachJobAndTransferAttributes do
  let(:miq_tasks_stub) { migration_stub(:MiqTask) }
  let(:jobs_stub) { migration_stub(:Job) }

  migration_context :up do
    it "deletes finished job older than 7 days" do
      jobs_stub.create!(:name => "Test Job1", :state => "finished", :updated_on => Time.now.utc - 6.days)
      jobs_stub.create!(:name => "Test Job2", :state => "finished", :updated_on => Time.now.utc - 8.days)
      jobs_stub.create!(:name => "Test Job3", :state => "finished", :updated_on => Time.now.utc - 1.month)

      migrate

      expect(jobs_stub.count).to eq 1
    end

    it "deletes finished tasks older than 7 days" do
      miq_tasks_stub.create!(:name => "Test Task1", :state => "Finished", :updated_on => Time.now.utc - 6.days)
      miq_tasks_stub.create!(:name => "Test Task2", :state => "Finished", :updated_on => Time.now.utc - 8.days)
      miq_tasks_stub.create!(:name => "Test Task2", :state => "Finished", :updated_on => Time.now.utc - 1.month)

      migrate

      expect(miq_tasks_stub.count).to eq 1
    end

    it "creates associated task for each job and assigns to task the same name" do
      jobs_stub.create!(:name => "Hello Test Job", :status => "Some test status", :miq_task_id => nil)
      jobs_stub.create!(:name => "Hello Test Job2", :state => "Some state", :miq_task_id => nil)

      migrate

      expect(miq_tasks_stub.count).to eq 2
      expect(miq_tasks_stub.find_by(:name => "Hello Test Job").status).to eq "Some test status"
      expect(miq_tasks_stub.find_by(:name => "Hello Test Job2").state).to eq "Some state"
    end
  end

  migration_context :down do
    it "delete all tasks associated with jobs" do
      job = jobs_stub.create!(:name => "Hello Test Job")
      task_with_job = miq_tasks_stub.create!(:name => "Hello Test Job")
      job.update_attributes(:miq_task_id => task_with_job.id)
      miq_tasks_stub.create!(:name => "Task without Job")
      miq_tasks_stub.create!(:name => "Another Task without Job")

      expect(miq_tasks_stub.count).to eq 3

      migrate

      expect(jobs_stub.count).to eq 1
      expect(miq_tasks_stub.count).to eq 2
      expect(jobs_stub.first.miq_task_id).to be nil
    end
  end
end
