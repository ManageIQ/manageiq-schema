require_migration

describe SubclassEmsCluster do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:ems_cluster_stub) { migration_stub(:EmsCluster) }

  let(:ems_row_entries) do
    [
      {:type => "ManageIQ::Providers::Kubevirt::InfraManager"},
      {:type => "ManageIQ::Providers::Microsoft::InfraManager"},
      {:type => "ManageIQ::Providers::Openstack::InfraManager"},
      {:type => "ManageIQ::Providers::Redhat::InfraManager"},
      {:type => "ManageIQ::Providers::Vmware::InfraManager"},
      {:type => "ManageIQ::Providers::AnotherManager"}
    ]
  end

  let(:row_entries) do
    [
      {
        :ems      => ems_row_entries[0],
        :name     => "cluster_1",
        :type_in  => nil,
        :type_out => 'ManageIQ::Providers::Kubevirt::InfraManager::Cluster'
      },
      {
        :ems      => ems_row_entries[1],
        :name     => "cluster_2",
        :type_in  => nil,
        :type_out => 'ManageIQ::Providers::Microsoft::InfraManager::Cluster'
      },
      {
        :ems      => ems_row_entries[2],
        :name     => "cluster_3",
        :type_in  => 'ManageIQ::Providers::Openstack::InfraManager::EmsCluster',
        :type_out => 'ManageIQ::Providers::Openstack::InfraManager::Cluster'
      },
      {
        :ems      => ems_row_entries[3],
        :name     => "cluster_4",
        :type_in  => nil,
        :type_out => 'ManageIQ::Providers::Redhat::InfraManager::Cluster'
      },
      {
        :ems      => ems_row_entries[4],
        :name     => "cluster_5",
        :type_in  => nil,
        :type_out => 'ManageIQ::Providers::Vmware::InfraManager::Cluster'
      },
      {
        :ems      => ems_row_entries[5],
        :name     => "cluster_6",
        :type_in  => nil,
        :type_out => nil
      },
    ]
  end

  migration_context :up do
    it "migrates a series of representative row" do
      ems_row_entries.each do |x|
        x[:ems] = ext_management_system_stub.create!(:type => x[:type])
      end

      row_entries.each do |x|
        x[:ems_cluster] = ems_cluster_stub.create!(:type => x[:type_in], :ems_id => x[:ems][:ems].id, :name => x[:name])
      end

      migrate

      row_entries.each do |x|
        expect(x[:ems_cluster].reload).to have_attributes(
                                            :type   => x[:type_out],
                                            :name   => x[:name],
                                            :ems_id => x[:ems][:ems].id
                                          )
      end
    end
  end

  migration_context :down do
    it "migrates a series of representative row" do
      ems_row_entries.each do |x|
        x[:ems] = ext_management_system_stub.create!(:type => x[:type])
      end

      row_entries.each do |x|
        x[:ems_cluster] = ems_cluster_stub.create!(:type => x[:type_out], :ems_id => x[:ems][:ems].id, :name => x[:name])
      end

      migrate

      row_entries.each do |x|
        expect(x[:ems_cluster].reload).to have_attributes(
                                            :type   => x[:type_in],
                                            :name   => x[:name],
                                            :ems_id => x[:ems][:ems].id
                                          )
      end
    end
  end
end
