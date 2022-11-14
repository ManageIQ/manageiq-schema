require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe RemoveVimStringsFromCustomAttributes do
  let(:custom_attribute_stub) { migration_stub(:CustomAttribute) }

  migration_context :up do
    it "converts VimStrings to String" do
      serialized_value = <<~SERIALIZED_VALUE
        ---
        !ruby/string:VimString
        str: BAR
        xsiType: :SOAP::SOAPString
        vimType:
      SERIALIZED_VALUE

      custom_attribute = custom_attribute_stub.create!(
        :section          => "custom_field",
        :name             => "FOO",
        :value            => "BAR",
        :source           => "VC",
        :serialized_value => serialized_value
      )

      migrate

      # We have to use YAML.load here instead of .safe_load because
      # otherwise it will fail with `Tried to load unspecified class: String`
      new_serialized_value = YAML.load(custom_attribute.reload.serialized_value)

      expect(new_serialized_value.class).to eq(String)
      expect(new_serialized_value).to eq("BAR")
    end

    it "doesn't impact standard strings" do
      custom_attribute = custom_attribute_stub.create!(
        :section          => "custom_field",
        :name             => "FOO",
        :value            => "BAR",
        :source           => "VC",
        :serialized_value => "BAR"
      )

      migrate

      custom_attribute.reload
      expect(custom_attribute.serialized_value.class).to eq(String)
      expect(custom_attribute.serialized_value).to eq("BAR")
    end
  end

  migration_context :down do
    it "resets VimStrings to String" do
      serialized_value = <<~SERIALIZED_VALUE
        ---
        !ruby/string:String
        str: BAR
        xsiType: :SOAP::SOAPString
        vimType:
      SERIALIZED_VALUE

      custom_attribute = custom_attribute_stub.create!(
        :section          => "custom_field",
        :name             => "FOO",
        :value            => "BAR",
        :source           => "VC",
        :serialized_value => serialized_value
      )

      migrate

      expect(custom_attribute.reload.serialized_value).to include("ruby/string:VimString")
    end

    it "doesn't impact standard strings" do
      custom_attribute = custom_attribute_stub.create!(
        :section          => "custom_field",
        :name             => "FOO",
        :value            => "BAR",
        :source           => "VC",
        :serialized_value => "BAR"
      )

      migrate

      custom_attribute.reload
      expect(custom_attribute.serialized_value.class).to eq(String)
      expect(custom_attribute.serialized_value).to eq("BAR")
    end
  end
end
