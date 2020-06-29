require_migration

describe RemoveVimStringsFromMiqProvision do
  let(:miq_request_task_stub) { migration_stub(:MiqRequestTask) }

  migration_context :up do
    it "converts VimStrings to Strings" do
      phase_context = <<~CONTEXT
        ---
        :new_vm_ems_ref: !ruby/string:VimString
        str: vm-123
        xsiType: :SOAP::SOAPString
        vimType: :VirtualMachine
      CONTEXT

      miq_request_task = miq_request_task_stub.create!(
        :phase_context => phase_context
      )

      migrate

      options = YAML.load(miq_request_task.reload.phase_context)
      expect(options[:new_vm_ems_ref].class).to eq(String)
    end
  end

  migration_context :down do
    it "restores String to VimString" do
      phase_context = <<~OPTIONS
        ---
        :error: !ruby/string:String
        str: vm-123
        xsiType: :SOAP::SOAPString
        vimType: :VirtualMachine
      OPTIONS

      miq_request_task = miq_request_task_stub.create!(
        :phase_context => phase_context
      )

      migrate

      phase_context = miq_request_task.reload.phase_context
      expect(phase_context).to include("ruby/string:VimString")
    end
  end
end
