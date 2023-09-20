require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RemoveVimStringsFromMiqQueue do
  let(:miq_queue_stub) { migration_stub(:MiqQueue) }

  migration_context :up do
    it "converts VimStrings to Strings" do
      queue_args = <<~CONTEXT
        ---
        - :event_type: DrsMigrateVM_Task
          :chain_id: &1 !ruby/string:VimString
            str: '12345678'
            xsiType: :SOAP::SOAPInt
            vimType:
          :is_task: true
          :source: VC
          :message: &3 !ruby/string:VimString
            str: 'Task: Migrate virtual machine'
            xsiType: :SOAP::SOAPString
            vimType:
          :timestamp: &2 !ruby/string:VimString
            str: '2022-10-06T06:40:59.901255Z'
            xsiType: :SOAP::SOAPDateTime
            vimType:
          :full_data: !ruby/hash-with-ivars:VimHash
            elements:
              key: !ruby/string:VimString
                str: '12345678'
                xsiType: :SOAP::SOAPInt
                vimType:
              chainId: *1
              createdTime: *2
              userName: !ruby/string:VimString
                str: ''
                xsiType: :SOAP::SOAPString
                vimType:
      CONTEXT

      queue_item = miq_queue_stub.create!(
        :args => queue_args
      )

      migrate
      queue_item.reload

      args = YAML.safe_load(queue_item.args, :permitted_classes => [Symbol, Date, String, Hash], :aliases => true)
      arg = args.first
      expect(arg.class).to eq(Hash)
      expect(arg[:chain_id].class).to eq(String)
    end
  end
end
