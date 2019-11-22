require_migration

describe UpdateOpenstackHostsUidEms do
  let(:host_stub) { migration_stub(:Host) }

  migration_context :up do
    it "updates the uid_ems to be the old ems_ref_obj" do
      host_instance_id = SecureRandom.uuid
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Openstack::InfraManager::Host",
        :ems_ref     => "some-other_ref",
        :ems_ref_obj => YAML.dump(host_instance_id),
        :uid_ems     => "some_other_ref"
      )

      migrate

      expect(host.reload.uid_ems).to eq(host_instance_id)
    end

    it "doesn't update non-openstack hosts" do
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Vmware::InfraManager::Host",
        :ems_ref     => "host-123",
        :ems_ref_obj => YAML.dump("host-123"),
        :uid_ems     => "abcd"
      )

      migrate

      expect(host.reload.uid_ems).to eq("abcd")
    end

    it "skips hosts with nil ems_ref_obj" do
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Openstack::InfraManager::Host",
        :ems_ref     => "some-other_ref",
        :ems_ref_obj => nil,
        :uid_ems     => "some_other_ref"
      )

      migrate

      expect(host.reload.uid_ems).to eq("some_other_ref")
    end
  end

  migration_context :down do
    it "updates the ems_ref_obj to be the uid_ems" do
      host_instance_id = SecureRandom.uuid
      host = host_stub.create!(
        :type    => "ManageIQ::Providers::Openstack::InfraManager::Host",
        :ems_ref => "some-other_ref",
        :uid_ems => host_instance_id
      )

      migrate

      host.reload
      expect(host.uid_ems).to     eq(host.ems_ref)
      expect(host.ems_ref_obj).to eq(YAML.dump(host_instance_id))
    end

    it "doesn't update non-openstack hosts" do
      host = host_stub.create!(
        :type        => "ManageIQ::Providers::Vmware::InfraManager::Host",
        :ems_ref     => "host-123",
        :ems_ref_obj => YAML.dump("host-123"),
        :uid_ems     => "abcd"
      )

      migrate

      expect(host.reload.uid_ems).to eq("abcd")
    end
  end
end
