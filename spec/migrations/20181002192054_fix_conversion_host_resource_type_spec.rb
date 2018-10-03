require_migration

class FixConversionHostResourceType < ActiveRecord::Migration[5.0]
  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  class Vm < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end
end

describe FixConversionHostResourceType do
  let(:conversion_host_stub) { migration_stub(:ConversionHost) }
  let(:host_stub)            { migration_stub(:Host) }
  let(:vm_stub)              { migration_stub(:Vm) }
  let(:conversion_host)      { conversion_host_stub.create! }
  let(:host)                 { host_stub.create! }
  let(:vm)                   { vm_stub.create! }

  migration_context :up do
    it "Updates invalid resource_types" do
      conversion_host.update_attributes!(
        :resource_id   => host.id,
        :resource_type => "AddConversionHostIdToMiqRequestTasks::Host"
      )

      migrate

      expect(conversion_host.reload.resource_type).to eq("Host")
    end

    it "Doesn't update valid resource_types" do
      conversion_host.update_attributes!(
        :resource_id   => vm.id,
        :resource_type => "Vm"
      )

      migrate

      expect(conversion_host.reload.resource_type).to eq("Vm")
    end
  end
end
