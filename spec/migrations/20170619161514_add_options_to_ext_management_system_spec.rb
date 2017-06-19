require_migration

describe AddOptionsToExtManagementSystem do
  let(:ems_stub)   { migration_stub(:ExtManagementSystem) }
  let(:ca_stub)    { migration_stub(:CustomAttribute) }
  let(:proxy_name) { "my_proxy" }

  migration_context :up do
    it "migrates proxy options form CustomAttribute" do
      kcp = ems_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager")
      kcp.custom_attributes.create!(:name    => "http_proxy",
                                    :section => "cluster_settings",
                                    :value   => proxy_name)

      migrate

      expect(kcp.reload).to have_attributes(
        :options => {:image_inspector_options => {:http_proxy => proxy_name}}
      )
      expect(ca_stub.where(:section => "cluster_settings").count).to eq(0)
    end
  end

  migration_context :down do
    it "it migrates proxy options to custom_attributes" do
      options = {:image_inspector_options => {:http_proxy => proxy_name}}
      kcp = ems_stub.create!(:type => "ManageIQ::Providers::Openshift::ContainerManager",
                             :options => options)

      migrate

      expect(kcp.reload.custom_attributes.find_by(:section => "cluster_settings",
                                                  :name    => "http_proxy").value).to eq(proxy_name)
      expect(ca_stub.where(:section => "cluster_settings").count).to eq(1)
    end
  end
end
