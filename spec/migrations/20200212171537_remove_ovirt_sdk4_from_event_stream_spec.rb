require_migration

describe RemoveOvirtSdk4FromEventStream do
  let(:event_stream_stub) { migration_stub(:EventStream) }

  migration_context :up do
    it "converts OvirtSDK4 Objects to a hash" do
      full_data = <<~FULL_DATA
        --- !ruby/object:OvirtSDK4::Event
        href: "/ovirt-engine/api/events/616040"
        name: USER_STARTED_VM
        cluster: !ruby/object:OvirtSDK4::Cluster
          href: "/ovirt-engine/api/clusters/00000002-0002-0002-0002-00000000024b"
          id: 00000002-0002-0002-0002-00000000024b
          name: Default
        data_center: !ruby/object:OvirtSDK4::DataCenter
          href: "/ovirt-engine/api/datacenters/00000001-0001-0001-0001-000000000123"
          id: 00000001-0001-0001-0001-000000000123
          name: Default
        host: !ruby/object:OvirtSDK4::Host
          href: "/ovirt-engine/api/hosts/f92aa108-3e37-4c76-ae81-5a5c6fc3e24d"
          id: f92aa108-3e37-4c76-ae81-5a5c6fc3e24d
        origin: oVirt
        severity: normal
        template: !ruby/object:OvirtSDK4::Template
          href: "/ovirt-engine/api/templates/e286b99b-bc49-4b7d-b265-3d82bfb5eac7"
          id: e286b99b-bc49-4b7d-b265-3d82bfb5eac7
          name: RHEL76_Base
        time: !ruby/object:DateTime 2019-02-20 05:15:48.290000000 -05:00
        user: !ruby/object:OvirtSDK4::User
          href: "/ovirt-engine/api/users/0000001a-001a-001a-001a-000000000392"
          id: 0000001a-001a-001a-001a-000000000392
          name: admin@internal-authz
        vm: !ruby/object:OvirtSDK4::Vm
          href: "/ovirt-engine/api/vms/b6c5d8ca-7db5-4372-bfd2-26d3c8116227"
          id: b6c5d8ca-7db5-4372-bfd2-26d3c8116227
          name: ocp311-master1
      FULL_DATA

      event = event_stream_stub.create!(:full_data => full_data, :source => "RHEVM")

      migrate

      full_data = YAML.load(event.reload.full_data)
      expect(full_data.class).to eq(Hash)
    end
  end
end
