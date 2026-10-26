require_migration

describe SetPhysicalServerVendorCisco do
  let(:physical_server_stub) { migration_stub(:PhysicalServer) }

  migration_context :up do
    it "updates the vendor of CiscoIntersight physical servers to cisco" do
      cisco_server = physical_server_stub.create!(
        :type   => "ManageIQ::Providers::CiscoIntersight::PhysicalInfraManager::PhysicalServer",
        :vendor => nil
      )
      other_server = physical_server_stub.create!(
        :type   => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalServer",
        :vendor => "lenovo"
      )

      migrate

      expect(cisco_server.reload.vendor).to eq("cisco")
      expect(other_server.reload.vendor).to eq("lenovo")
    end
  end

  migration_context :down do
    it "reverts the vendor of CiscoIntersight physical servers to nil" do
      cisco_server = physical_server_stub.create!(
        :type   => "ManageIQ::Providers::CiscoIntersight::PhysicalInfraManager::PhysicalServer",
        :vendor => "cisco"
      )
      other_server = physical_server_stub.create!(
        :type   => "ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalServer",
        :vendor => "lenovo"
      )

      migrate

      expect(cisco_server.reload.vendor).to be_nil
      expect(other_server.reload.vendor).to eq("lenovo")
    end
  end
end
