require_migration

describe UpdateAmazonTagMapperResourceType do
  let(:provider_tag_mapping_stub) { migration_stub(:ProviderTagMapping) }

  migration_context :up do
    it "Converts Vm and Image to VmAmazon and ImageAmazon" do
      vm_mapping    = provider_tag_mapping_stub.create!(:labeled_resource_type => "Vm")
      image_mapping = provider_tag_mapping_stub.create!(:labeled_resource_type => "Image")

      migrate

      expect(vm_mapping.reload.labeled_resource_type).to eq("VmAmazon")
      expect(image_mapping.reload.labeled_resource_type).to eq("ImageAmazon")
    end

    it "Doesn't update other tag mappings" do
      vm_mapping = provider_tag_mapping_stub.create!(:labeled_resource_type => "VmOpenstack")

      migrate

      expect(vm_mapping.reload.labeled_resource_type).to eq("VmOpenstack")
    end
  end

  migration_context :down do
    it "Converts VmAmazon and ImageAmazon to Vm and Image" do
      vm_mapping    = provider_tag_mapping_stub.create!(:labeled_resource_type => "VmAmazon")
      image_mapping = provider_tag_mapping_stub.create!(:labeled_resource_type => "ImageAmazon")

      migrate

      expect(vm_mapping.reload.labeled_resource_type).to eq("Vm")
      expect(image_mapping.reload.labeled_resource_type).to eq("Image")
    end

    it "Doesn't update other tag mappings" do
      vm_mapping = provider_tag_mapping_stub.create!(:labeled_resource_type => "VmOpenstack")

      migrate

      expect(vm_mapping.reload.labeled_resource_type).to eq("VmOpenstack")
    end
  end
end
