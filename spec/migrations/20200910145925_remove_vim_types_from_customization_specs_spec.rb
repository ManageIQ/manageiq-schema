require_migration

describe RemoveVimTypesFromCustomizationSpecs do
  let(:customization_spec_stub) { migration_stub(:CustomizationSpec) }

  migration_context :up do
    it "converts VimTypes to a normal types" do
      spec = <<~SPEC
        --- !ruby/hash-with-ivars:VimHash
        ivars:
          :@xsiType: :CustomizationSpecItem
          :@vimType:
        elements:
          info: !ruby/hash-with-ivars:VimHash
            ivars:
              :@xsiType: :CustomizationSpecInfo
              :@vimType:
            elements:
              name: !ruby/string:VimString
                str: custom1
                xsiType: :SOAP::SOAPString
                vimType:
              description: !ruby/string:VimString
                str: ''
                xsiType: :SOAP::SOAPString
                vimType:
              type: !ruby/string:VimString
                str: Linux
                xsiType: :SOAP::SOAPString
                vimType:
              changeVersion: !ruby/string:VimString
                str: '1590082846'
                xsiType: :SOAP::SOAPString
                vimType:
              lastUpdateTime: !ruby/string:VimString
                str: '2020-05-21T17:40:46Z'
                xsiType: :SOAP::SOAPDateTime
                vimType:
          spec: !ruby/hash-with-ivars:VimHash
            ivars:
              :@xsiType: :CustomizationSpec
              :@vimType:
            elements:
              options: !ruby/hash-with-ivars:VimHash
                ivars:
                  :@xsiType: :CustomizationLinuxOptions
                  :@vimType:
                elements: {}
              identity: !ruby/hash-with-ivars:VimHash
                ivars:
                  :@xsiType: :CustomizationLinuxPrep
                  :@vimType:
                elements:
                  hostName: !ruby/hash-with-ivars:VimHash
                    ivars:
                      :@xsiType: :CustomizationPrefixName
                      :@vimType:
                    elements:
                      base: !ruby/string:VimString
                        str: custom-hostname
                        xsiType: :SOAP::SOAPString
                        vimType:
                  domain: !ruby/string:VimString
                    str: cloudforms.lab.eng.rdu2.redhat.com
                    xsiType: :SOAP::SOAPString
                    vimType:
                  timeZone: !ruby/string:VimString
                    str: America/Los_Angeles
                    xsiType: :SOAP::SOAPString
                    vimType:
                  hwClockUTC: !ruby/string:VimString
                    str: 'true'
                    xsiType: :SOAP::SOAPBoolean
                    vimType:
              globalIPSettings: !ruby/hash-with-ivars:VimHash
                ivars:
                  :@xsiType: :CustomizationGlobalIPSettings
                  :@vimType:
                elements: {}
              nicSettingMap: !ruby/array:VimArray
                internal:
                - !ruby/hash-with-ivars:VimHash
                  ivars:
                    :@xsiType: :CustomizationAdapterMapping
                    :@vimType:
                  elements:
                    adapter: !ruby/hash-with-ivars:VimHash
                      ivars:
                        :@xsiType: :CustomizationIPSettings
                        :@vimType:
                      elements:
                        ip: !ruby/hash-with-ivars:VimHash
                          ivars:
                            :@xsiType: :CustomizationDhcpIpGenerator
                            :@vimType:
                          elements: {}
                ivars:
                  :@xsiType: :ArrayOfCustomizationAdapterMapping
                  :@vimType:

      SPEC

      customization_spec = customization_spec_stub.create!(:spec => spec)

      migrate

      spec = YAML.load(customization_spec.reload.spec)

      expect(spec.class).to eq(Hash)
      expect(spec.dig("info", "name").class).to eq(String)
      expect(spec.dig("info", "name")).to eq("custom1")

      expect(spec.dig("spec", "identity").class).to eq(Hash)
      expect(spec.dig("spec", "identity")).to include(
        "hostName"   => {
          "base" => "custom-hostname"
        },
        "domain"     => "cloudforms.lab.eng.rdu2.redhat.com",
        "timeZone"   => "America/Los_Angeles",
        "hwClockUTC" => "true"
      )

      expect(spec.dig("spec", "nicSettingMap").class).to eq(Array)
      expect(spec.dig("spec", "nicSettingMap").count).to eq(1)
      expect(spec.dig("spec", "nicSettingMap").first.class).to eq(Hash)
      expect(spec.dig("spec", "nicSettingMap").first).to include("adapter"=>{"ip"=>{}})
    end
  end

  migration_context :down do
    it "converts Hash/String/Array to Vim Types" do
      spec = <<~SPEC
        --- !ruby/hash-with-ivars:Hash
        ivars:
          :@xsiType: :CustomizationSpecItem
          :@vimType:
        elements:
          info: !ruby/hash-with-ivars:Hash
            ivars:
              :@xsiType: :CustomizationSpecInfo
              :@vimType:
            elements:
              name: !ruby/string:String
                str: custom1
                xsiType: :SOAP::SOAPString
                vimType:
              description: !ruby/string:String
                str: ''
                xsiType: :SOAP::SOAPString
                vimType:
              type: !ruby/string:String
                str: Linux
                xsiType: :SOAP::SOAPString
                vimType:
              changeVersion: !ruby/string:String
                str: '1590082846'
                xsiType: :SOAP::SOAPString
                vimType:
              lastUpdateTime: !ruby/string:String
                str: '2020-05-21T17:40:46Z'
                xsiType: :SOAP::SOAPDateTime
                vimType:
          spec: !ruby/hash-with-ivars:Hash
            ivars:
              :@xsiType: :CustomizationSpec
              :@vimType:
            elements:
              options: !ruby/hash-with-ivars:Hash
                ivars:
                  :@xsiType: :CustomizationLinuxOptions
                  :@vimType:
                elements: {}
              identity: !ruby/hash-with-ivars:Hash
                ivars:
                  :@xsiType: :CustomizationLinuxPrep
                  :@vimType:
                elements:
                  hostName: !ruby/hash-with-ivars:Hash
                    ivars:
                      :@xsiType: :CustomizationPrefixName
                      :@vimType:
                    elements:
                      base: !ruby/string:String
                        str: custom-hostname
                        xsiType: :SOAP::SOAPString
                        vimType:
                  domain: !ruby/string:String
                    str: cloudforms.lab.eng.rdu2.redhat.com
                    xsiType: :SOAP::SOAPString
                    vimType:
                  timeZone: !ruby/string:String
                    str: America/Los_Angeles
                    xsiType: :SOAP::SOAPString
                    vimType:
                  hwClockUTC: !ruby/string:String
                    str: 'true'
                    xsiType: :SOAP::SOAPBoolean
                    vimType:
              globalIPSettings: !ruby/hash-with-ivars:Hash
                ivars:
                  :@xsiType: :CustomizationGlobalIPSettings
                  :@vimType:
                elements: {}
              nicSettingMap: !ruby/array:Array
                internal:
                - !ruby/hash-with-ivars:Hash
                  ivars:
                    :@xsiType: :CustomizationAdapterMapping
                    :@vimType:
                  elements:
                    adapter: !ruby/hash-with-ivars:Hash
                      ivars:
                        :@xsiType: :CustomizationIPSettings
                        :@vimType:
                      elements:
                        ip: !ruby/hash-with-ivars:Hash
                          ivars:
                            :@xsiType: :CustomizationDhcpIpGenerator
                            :@vimType:
                          elements: {}
                ivars:
                  :@xsiType: :ArrayOfCustomizationAdapterMapping
                  :@vimType:

      SPEC

      customization_spec = customization_spec_stub.create!(:spec => spec)

      migrate

      spec = customization_spec.reload.spec
      expect(spec).to include("ruby/hash-with-ivars:VimHash")
      expect(spec).to include("ruby/string:VimString")
      expect(spec).to include("ruby/array:VimArray")
    end
  end
end
