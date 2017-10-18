require_migration

describe FixHawkularEndpointsWithPortNil do
  let(:ext_management_system_stub) { migration_stub(:ExtManagementSystem) }
  let(:endpoint_stub) { migration_stub(:Endpoint) }

  migration_context :up do
    it 'Modifies hawkular endpoints with nil port' do
      ems = ext_management_system_stub.create!(
        :name => 'container',
        :type => 'ManageIQ::Providers::Openshift::ContainerManager'
      )
      hawk = endpoint_stub.create!(
        :role          => "hawkular",
        :hostname      => "hawkname",
        :port          => nil,
        :resource_type => "ExtManagementSystem",
        :resource_id   => ems.id
      )

      migrate

      expect(hawk.reload.port).to eq(443)
    end

    it 'Does not modify non-nil port, or non-containers-hawkular endpoints' do
      ems = ext_management_system_stub.create!(
        :name => 'container',
        :type => 'ManageIQ::Providers::Openshift::ContainerManager'
      )
      hawk = endpoint_stub.create!(
        :role          => "hawkular",
        :hostname      => "hawkname",
        :port          => 123,
        :resource_type => "ExtManagementSystem",
        :resource_id   => ems.id
      )
      main = endpoint_stub.create!(
        :role          => "default",
        :hostname      => "hostname",
        :port          => nil,
        :resource_type => "ExtManagementSystem",
        :resource_id   => ems.id
      )

      other_ems = ext_management_system_stub.create!(
        :name => 'container',
        :type => 'ManageIQ::Providers::Amazon::CloudManager'
      )
      other = endpoint_stub.create!(
        :role          => "unrelated",
        :hostname      => "neverwhere",
        :port          => nil,
        :resource_type => "ExtManagementSystem",
        :resource_id   => other_ems.id
      )

      migrate

      expect(hawk.reload.port).to eq(123)
      expect(main.reload.port).to eq(nil)
      expect(other.reload.port).to eq(nil)
    end
  end
end
