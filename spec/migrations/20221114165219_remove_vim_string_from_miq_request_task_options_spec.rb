require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RemoveVimStringFromMiqRequestTaskOptions do
  let(:miq_request_task_stub) { migration_stub(:MiqRequestTask) }

  migration_context :up do
    it "Converts VimStrings to String" do
      options_value = <<~OPTIONS_VALUE
        ---
        name: ems_ref_obj
        value_before_type_cast: |
          --- !ruby/string:VimString
          str: domain-c4006
          xsiType: :ManagedObjectReference
          vimType: :ClusterComputeResource\n
      OPTIONS_VALUE

      miq_request_task = miq_request_task_stub.create!(
        :options => options_value
      )

      migrate

      expect(miq_request_task.reload.options).not_to include("VimString")
    end

    it "doesn't impact standard strings" do
      miq_request_task = miq_request_task_stub.create!(
        :options => "---\name: ems_ref\nvalue: vm-1"
      )

      migrate

      expect(miq_request_task.reload.options).to eq("---\name: ems_ref\nvalue: vm-1")
    end
  end

  migration_context :down do
    it "Resets VimStrings" do
      options_value = <<~OPTIONS_VALUE
        ---
        name: ems_ref_obj
        value_before_type_cast: |
          --- !ruby/string:String
          str: domain-c4006
          xsiType: :ManagedObjectReference
          vimType: :ClusterComputeResource\n
      OPTIONS_VALUE

      miq_request_task = miq_request_task_stub.create!(
        :options => options_value
      )

      migrate

      expect(miq_request_task.reload.options).to include("VimString")
    end

    it "doesn't impact standard strings" do
      miq_request_task = miq_request_task_stub.create!(
        :options => "---\name: ems_ref\nvalue: vm-1"
      )

      migrate

      expect(miq_request_task.reload.options).to eq("---\name: ems_ref\nvalue: vm-1")
    end
  end
end
