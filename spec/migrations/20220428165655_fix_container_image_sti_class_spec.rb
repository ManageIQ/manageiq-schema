require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixContainerImageStiClass do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:container_image_stub)       { migration_stub(:ContainerImage) }

  migration_context :up do
    it "updates ContainerImage STI classes" do
      openshift_manager       = ext_management_system_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      openshift_managed_image = container_image_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage", :ext_management_system => openshift_manager)
      openshift_docker_image  = container_image_stub.create!(:type => nil, :ext_management_system => openshift_manager)

      # Create data
      #
      # Example:
      #
      #   my_model_stub.create!(attributes)

      migrate

      # Ensure data exists
      #
      # Example:
      #
      #   expect(record).to have_attributes()
      expect(openshift_managed_image.reload.type).to eq("ManageIQ::Providers::Openshift::ContainerManager::ManagedContainerImage")
      expect(openshift_docker_image.reload.type).to  eq("ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
    end
  end

  migration_context :down do
    it "reverts ContainerImage STI classes" do
      openshift_manager       = ext_management_system_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      openshift_managed_image = container_image_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager::ManagedContainerImage", :ext_management_system => openshift_manager)
      openshift_docker_image  = container_image_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerImage", :ext_management_system => openshift_manager)

      # Create data
      #
      # Example:
      #
      #   my_model_stub.create!(attributes)

      migrate

      # Ensure data exists
      #
      # Example:
      #
      #   expect(record).to have_attributes()
      expect(openshift_managed_image.reload.type).to eq("ManageIQ::Providers::Openshift::ContainerManager::ContainerImage")
      expect(openshift_docker_image.reload.type).to  be_nil
    end
  end
end
