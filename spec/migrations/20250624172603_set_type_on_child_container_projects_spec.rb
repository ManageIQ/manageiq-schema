require_migration

describe SetTypeOnChildContainerProjects do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:container_project_stub)     { migration_stub(:ContainerProject) }

  migration_context :up do
    it "sets STI type for providers" do
      eks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Amazon::ContainerManager")
      aks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Azure::ContainerManager")
      gke   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Google::ContainerManager")
      iks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::IbmCloud::ContainerManager")
      k8s   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Kubernetes::ContainerManager")
      ocp   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      oke   = ext_management_system_stub.create(:type => "ManageIQ::Providers::OracleCloud::ContainerManager")
      tanzu = ext_management_system_stub.create(:type => "ManageIQ::Providers::Vmware::ContainerManager")

      eks_project   = container_project_stub.create(:ems_id => eks.id)
      aks_project   = container_project_stub.create(:ems_id => aks.id)
      gke_project   = container_project_stub.create(:ems_id => gke.id)
      iks_project   = container_project_stub.create(:ems_id => iks.id)
      k8s_project   = container_project_stub.create(:ems_id => k8s.id)
      ocp_project   = container_project_stub.create(:ems_id => ocp.id)
      oke_project   = container_project_stub.create(:ems_id => oke.id)
      tanzu_project = container_project_stub.create(:ems_id => tanzu.id)

      migrate

      expect(eks_project.reload.type).to   eq("ManageIQ::Providers::Amazon::ContainerManager::ContainerProject")
      expect(aks_project.reload.type).to   eq("ManageIQ::Providers::Azure::ContainerManager::ContainerProject")
      expect(gke_project.reload.type).to   eq("ManageIQ::Providers::Google::ContainerManager::ContainerProject")
      expect(iks_project.reload.type).to   eq("ManageIQ::Providers::IbmCloud::ContainerManager::ContainerProject")
      expect(k8s_project.reload.type).to   eq("ManageIQ::Providers::Kubernetes::ContainerManager::ContainerProject")
      expect(ocp_project.reload.type).to   eq("ManageIQ::Providers::Openshift::ContainerManager::ContainerProject")
      expect(oke_project.reload.type).to   eq("ManageIQ::Providers::OracleCloud::ContainerManager::ContainerProject")
      expect(tanzu_project.reload.type).to eq("ManageIQ::Providers::Vmware::ContainerManager::ContainerProject")
    end
  end

  migration_context :down do
    it "clears the type column" do
      eks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Amazon::ContainerManager")
      aks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Azure::ContainerManager")
      gke   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Google::ContainerManager")
      iks   = ext_management_system_stub.create(:type => "ManageIQ::Providers::IbmCloud::ContainerManager")
      k8s   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Kubernetes::ContainerManager")
      ocp   = ext_management_system_stub.create(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      oke   = ext_management_system_stub.create(:type => "ManageIQ::Providers::OracleCloud::ContainerManager")
      tanzu = ext_management_system_stub.create(:type => "ManageIQ::Providers::Vmware::ContainerManager")

      eks_project   = container_project_stub.create(:ems_id => eks.id,   :type => "ManageIQ::Providers::Amazon::ContainerManager::ContainerProject")
      aks_project   = container_project_stub.create(:ems_id => aks.id,   :type => "ManageIQ::Providers::Azure::ContainerManager::ContainerProject")
      gke_project   = container_project_stub.create(:ems_id => gke.id,   :type => "ManageIQ::Providers::Google::ContainerManager::ContainerProject")
      iks_project   = container_project_stub.create(:ems_id => iks.id,   :type => "ManageIQ::Providers::IbmCloud::ContainerManager::ContainerProject")
      k8s_project   = container_project_stub.create(:ems_id => k8s.id,   :type => "ManageIQ::Providers::Kubernetes::ContainerManager::ContainerProject")
      ocp_project   = container_project_stub.create(:ems_id => ocp.id,   :type => "ManageIQ::Providers::Openshift::ContainerManager::ContainerProject")
      oke_project   = container_project_stub.create(:ems_id => oke.id,   :type => "ManageIQ::Providers::OracleCloud::ContainerManager::ContainerProject")
      tanzu_project = container_project_stub.create(:ems_id => tanzu.id, :type => "ManageIQ::Providers::Vmware::ContainerManager::ContainerProject")

      migrate

      expect(eks_project.reload.type).to   be_nil
      expect(aks_project.reload.type).to   be_nil
      expect(gke_project.reload.type).to   be_nil
      expect(iks_project.reload.type).to   be_nil
      expect(k8s_project.reload.type).to   be_nil
      expect(ocp_project.reload.type).to   be_nil
      expect(oke_project.reload.type).to   be_nil
      expect(tanzu_project.reload.type).to be_nil
    end
  end
end
