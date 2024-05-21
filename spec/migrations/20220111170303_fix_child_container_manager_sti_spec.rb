require_migration

# This is mostly necessary for data migrations, so feel free to delete this
# file if you do no need it.
describe FixChildContainerManagerSti do
  let(:ext_management_system_stub)  { migration_stub(:ExtManagementSystem) }
  let(:container_template_stub)     { migration_stub(:ContainerTemplate) }
  let(:service_instance_stub)       { migration_stub(:ServiceInstance) }
  let(:service_offering_stub)       { migration_stub(:ServiceOffering) }
  let(:service_parameters_set_stub) { migration_stub(:ServiceParametersSet) }

  migration_context :up do
    it "fixes STI class for EKS providers" do
      eks = ext_management_system_stub.create(:type => "ManageIQ::Providers::Amazon::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => eks)
      service_instance       = service_instance_stub.create(:ext_management_system => eks)
      service_offering       = service_offering_stub.create(:ext_management_system => eks)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => eks)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::Amazon::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::Amazon::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::Amazon::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::Amazon::ContainerManager::ServiceParametersSet")
    end

    it "fixes STI class for AKS providers" do
      aks = ext_management_system_stub.create(:type => "ManageIQ::Providers::Azure::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => aks)
      service_instance       = service_instance_stub.create(:ext_management_system => aks)
      service_offering       = service_offering_stub.create(:ext_management_system => aks)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => aks)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::Azure::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::Azure::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::Azure::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::Azure::ContainerManager::ServiceParametersSet")
    end

    it "fixes STI class for GKE providers" do
      gke = ext_management_system_stub.create(:type => "ManageIQ::Providers::Google::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => gke)
      service_instance       = service_instance_stub.create(:ext_management_system => gke)
      service_offering       = service_offering_stub.create(:ext_management_system => gke)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => gke)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::Google::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::Google::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::Google::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::Google::ContainerManager::ServiceParametersSet")
    end

    it "fixes STI class for IKS providers" do
      iks = ext_management_system_stub.create(:type => "ManageIQ::Providers::IbmCloud::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => iks)
      service_instance       = service_instance_stub.create(:ext_management_system => iks)
      service_offering       = service_offering_stub.create(:ext_management_system => iks)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => iks)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::IbmCloud::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::IbmCloud::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::IbmCloud::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::IbmCloud::ContainerManager::ServiceParametersSet")
    end

    it "fixes STI class for OKE providers" do
      oke = ext_management_system_stub.create(:type => "ManageIQ::Providers::OracleCloud::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => oke)
      service_instance       = service_instance_stub.create(:ext_management_system => oke)
      service_offering       = service_offering_stub.create(:ext_management_system => oke)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => oke)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::OracleCloud::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::OracleCloud::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::OracleCloud::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::OracleCloud::ContainerManager::ServiceParametersSet")
    end

    it "fixes STI class for Tanzu providers" do
      tanzu = ext_management_system_stub.create(:type => "ManageIQ::Providers::Vmware::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => tanzu)
      service_instance       = service_instance_stub.create(:ext_management_system => tanzu)
      service_offering       = service_offering_stub.create(:ext_management_system => tanzu)
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => tanzu)

      migrate

      expect(container_template_stub.first.type).to     eq("ManageIQ::Providers::Vmware::ContainerManager::ContainerTemplate")
      expect(service_instance_stub.first.type).to       eq("ManageIQ::Providers::Vmware::ContainerManager::ServiceInstance")
      expect(service_offering_stub.first.type).to       eq("ManageIQ::Providers::Vmware::ContainerManager::ServiceOffering")
      expect(service_parameters_set_stub.first.type).to eq("ManageIQ::Providers::Vmware::ContainerManager::ServiceParametersSet")
    end
  end

  migration_context :down do
    it "resets STI class for EKS providers" do
      eks = ext_management_system_stub.create(:type => "ManageIQ::Providers::Amazon::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => eks, :type => "ManageIQ::Providers::Amazon::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => eks, :type => "ManageIQ::Providers::Amazon::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => eks, :type => "ManageIQ::Providers::Amazon::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => eks, :type => "ManageIQ::Providers::Amazon::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end

    it "resets STI class for AKS providers" do
      aks = ext_management_system_stub.create(:type => "ManageIQ::Providers::Azure::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => aks, :type => "ManageIQ::Providers::Azure::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => aks, :type => "ManageIQ::Providers::Azure::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => aks, :type => "ManageIQ::Providers::Azure::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => aks, :type => "ManageIQ::Providers::Azure::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end

    it "resets STI class for GKE providers" do
      gke = ext_management_system_stub.create(:type => "ManageIQ::Providers::Google::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => gke, :type => "ManageIQ::Providers::Google::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => gke, :type => "ManageIQ::Providers::Google::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => gke, :type => "ManageIQ::Providers::Google::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => gke, :type => "ManageIQ::Providers::Google::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end

    it "resets STI class for IKS providers" do
      iks = ext_management_system_stub.create(:type => "ManageIQ::Providers::IbmCloud::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => iks, :type => "ManageIQ::Providers::IbmCloud::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => iks, :type => "ManageIQ::Providers::IbmCloud::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => iks, :type => "ManageIQ::Providers::IbmCloud::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => iks, :type => "ManageIQ::Providers::IbmCloud::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end

    it "resets STI class for OKE providers" do
      oke = ext_management_system_stub.create(:type => "ManageIQ::Providers::OracleCloud::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => oke, :type => "ManageIQ::Providers::OracleCloud::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => oke, :type => "ManageIQ::Providers::OracleCloud::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => oke, :type => "ManageIQ::Providers::OracleCloud::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => oke, :type => "ManageIQ::Providers::OracleCloud::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end

    it "resets STI class for Tanzu providers" do
      tanzu = ext_management_system_stub.create(:type => "ManageIQ::Providers::Vmware::ContainerManager")

      container_template     = container_template_stub.create(:ext_management_system => tanzu, :type => "ManageIQ::Providers::Vmware::ContainerManager::ContainerTemplate")
      service_instance       = service_instance_stub.create(:ext_management_system => tanzu, :type => "ManageIQ::Providers::Vmware::ContainerManager::ServiceInstance")
      service_offering       = service_offering_stub.create(:ext_management_system => tanzu, :type => "ManageIQ::Providers::Vmware::ContainerManager::ServiceOffering")
      service_parameters_set = service_parameters_set_stub.create(:ext_management_system => tanzu, :type => "ManageIQ::Providers::Vmware::ContainerManager::ServiceParametersSet")

      migrate

      expect(container_template_stub.first.type).to     be_nil
      expect(service_instance_stub.first.type).to       be_nil
      expect(service_offering_stub.first.type).to       be_nil
      expect(service_parameters_set_stub.first.type).to be_nil
    end
  end
end
