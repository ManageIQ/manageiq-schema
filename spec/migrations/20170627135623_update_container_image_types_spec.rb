require_migration

describe UpdateContainerImageTypes do
  let(:container_image_stub) { migration_stub(:ContainerImage) }

  migration_context :up do
    it "setting type correctly" do
      container_image = container_image_stub.create!
      openshift_container_image = container_image_stub.create!(:size => 12_345)

      migrate

      expect(container_image.reload).to have_attributes(:type => "ContainerImage")
      expect(openshift_container_image.reload).to have_attributes(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
    end
  end
end
