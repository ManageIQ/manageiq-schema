require_migration

describe RemoveVimTypesFromEmsEvents do
  let(:event_stream_stub) { migration_stub(:EventStream) }

  migration_context :up do
    it "converts VimTypes to a normal types" do
      full_data = <<~FULL_DATA
        --- !ruby/hash-with-ivars:VimHash
        elements:
          key: !ruby/string:VimString
            str: '585137'
            xsiType: :SOAP::SOAPInt
            vimType:
          datacenter: !ruby/hash-with-ivars:VimHash
            elements:
              name: !ruby/string:VimString
                str: dev-vc67-DC
                xsiType: :SOAP::SOAPString
                vimType:
              datacenter: !ruby/string:VimString
                str: datacenter-104
                xsiType: :ManagedObjectReference
                vimType: :Datacenter
            ivars:
              :@xsiType: :DatacenterEventArgument
              :@vimType:
          eventType: VmCreatedEvent
          arguments: !ruby/array:VimArray
            internal:
            - !ruby/hash-with-ivars:VimHash
              elements:
                datacenter: !ruby/string:VimString
                  str: datacenter-104
                  xsiType: :Datacenter
                  vimType: :ManagedObjectReference
              ivars:
                :@xsiType: :DatacenterArgument
                :@vimType:
            ivars:
              :@xsiType: :KeyAnyValue
              :@vimType:
        ivars:
          :@xsiType: :VmCreatedEvent
          :@vimType:

      FULL_DATA

      event = event_stream_stub.create!(:full_data => full_data, :source => "VC")

      migrate

      full_data = YAML.load(event.reload.full_data)

      expect(full_data.class).to eq(Hash)
      expect(full_data["key"].class).to eq(String)
      expect(full_data["key"]).to eq("585137")
      expect(full_data["datacenter"].class).to eq(Hash)
      expect(full_data["datacenter"]).to include(
        "name"       => "dev-vc67-DC",
        "datacenter" => "datacenter-104"
      )
      expect(full_data["arguments"].class).to eq(Array)
      expect(full_data["arguments"].count).to eq(1)
      expect(full_data["arguments"].first.class).to eq(Hash)
      expect(full_data["arguments"].first).to include("datacenter" => "datacenter-104")
    end
  end

  migration_context :down do
    it "converts Hash/String/Array to Vim Types" do
      full_data = <<~FULL_DATA
        --- !ruby/hash-with-ivars:Hash
        elements:
          key: !ruby/string:String
            str: '585137'
            xsiType: :SOAP::SOAPInt
            vimType:
          datacenter: !ruby/hash-with-ivars:Hash
            elements:
              name: !ruby/string:String
                str: dev-vc67-DC
                xsiType: :SOAP::SOAPString
                vimType:
              datacenter: !ruby/string:String
                str: datacenter-104
                xsiType: :ManagedObjectReference
                vimType: :Datacenter
            ivars:
              :@xsiType: :DatacenterEventArgument
              :@vimType:
          eventType: VmCreatedEvent
          arguments: !ruby/array:Array
            internal:
            - !ruby/hash-with-ivars:Hash
              elements:
                datacenter: !ruby/string:String
                  str: datacenter-104
                  xsiType: :Datacenter
                  vimType: :ManagedObjectReference
              ivars:
                :@xsiType: :DatacenterArgument
                :@vimType:
            ivars:
              :@xsiType: :KeyAnyValue
              :@vimType:
        ivars:
          :@xsiType: :VmCreatedEvent
          :@vimType:

      FULL_DATA

      event = event_stream_stub.create!(:full_data => full_data, :source => "VC")

      migrate

      full_data = event.reload.full_data
      expect(full_data).to include("ruby/hash-with-ivars:VimHash")
      expect(full_data).to include("ruby/string:VimString")
      expect(full_data).to include("ruby/array:VimArray")
    end
  end
end
