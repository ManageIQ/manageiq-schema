require_migration

describe RemoveVimTypesFromEmsEvents do
  let(:event_stream_stub) { migration_stub(:EventStream) }

  migration_context :up do
    it "converts a VimHash to a normal Hash" do
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
    end
  end
end
