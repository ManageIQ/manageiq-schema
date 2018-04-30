require_migration

describe AzureBackslashToForwardSlash do
  let(:vm_stub) { migration_stub :Vm }
  let(:stack_stub) { migration_stub :OrchestrationStack }
  let(:stack_output_stub) { migration_stub :OrchestrationStackOutput }
  let(:stack_param_stub) { migration_stub :OrchestrationStackParameter }
  let(:stack_resource_stub) { migration_stub :OrchestrationStackResource }
  let(:event_stream_stub) { migration_stub :EventStream }

  migration_context :up do
    context "virtual machines" do
      it 'Converts backslashes to forward slashes for the ems_ref, uid_ems and description for vms' do
        vm = vm_stub.create!(
          :name        => 'azure_test_vm',
          :ems_ref     => 'xyz\some_group\microsoft.compute/virtualmachines\foo',
          :uid_ems     => 'xyz\some_group\microsoft.compute/virtualmachines\foo',
          :type        => 'ManageIQ::Providers::Azure::CloudManager::Vm',
          :description => 'some\description'
        )

        migrate
        vm.reload

        expect(vm.ems_ref).to eql('xyz/some_group/microsoft.compute/virtualmachines/foo')
        expect(vm.uid_ems).to eql('xyz/some_group/microsoft.compute/virtualmachines/foo')
        expect(vm.description).to eql('some/description')
      end

      it 'Converts backslashes to forward slashes for the ems_ref and description for templates' do
        template = vm_stub.create!(
          :name        => 'azure_test_template',
          :ems_ref     => 'xyz\some_group\microsoft.compute/virtualmachines\bar',
          :uid_ems     => 'xyz\some_group\microsoft.compute/virtualmachines\bar',
          :type        => 'ManageIQ::Providers::Azure::CloudManager::Template',
          :description => 'some\other\description'
        )

        migrate
        template.reload

        expect(template.ems_ref).to eql('xyz/some_group/microsoft.compute/virtualmachines/bar')
        expect(template.uid_ems).to eql('xyz/some_group/microsoft.compute/virtualmachines/bar')
        expect(template.description).to eql('some/other/description')
      end
    end

    context "orchestration" do
      let!(:stack) do
        stack_stub.create!(
          :name    => 'azure_test_stack',
          :ems_ref => 'xyz/resourceGroups\foo\providers/Microsoft.Resources/deployments/stuff',
          :type    => 'ManageIQ::Providers::Azure::CloudManager::OrchestrationStack'
        )
      end

      it 'Converts backslashes to forward slashes in the ems_ref column for orchestration stacks' do
        migrate
        stack.reload
        expect(stack.ems_ref).to eql('xyz/resourceGroups/foo/providers/Microsoft.Resources/deployments/stuff')
      end

      it 'Converts backslashes to forward slashes in the ems_ref column for orchestration stack output' do
        stack_output = stack_output_stub.create!(
          :stack_id => stack.id,
          :key      => 'adminUserName',
          :value    => 'me',
          :ems_ref  => '/subscriptions/xyz/resourceGroups/some_group/providers/Microsoft.Resources/deployments/RedHat\adminUsername'
        )

        migrate
        stack_output.reload

        expect(stack_output.ems_ref).to eql('/subscriptions/xyz/resourceGroups/some_group/providers/Microsoft.Resources/deployments/RedHat/adminUsername')
      end

      it 'Converts backslashes to forward slashes in the ems_ref column for orchestration stack parameter' do
        stack_param = stack_param_stub.create!(
          :stack_id => stack.id,
          :name     => 'location',
          :value    => 'westus',
          :ems_ref  => '/subscriptions/xyz/resourceGroups/some_group/providers/Microsoft.Resources/deployments/RedHat\location'
        )

        migrate
        stack_param.reload

        expect(stack_param.ems_ref).to eql('/subscriptions/xyz/resourceGroups/some_group/providers/Microsoft.Resources/deployments/RedHat/location')
      end

      it 'Converts backslashes to forward slashes in the ems_ref column for orchestration stack resource' do
        stack_resource = stack_resource_stub.create!(
          :stack_id         => stack.id,
          :name             => 'nsg',
          :logical_resource => 'something',
          :ems_ref          => '/subscriptions/xyz\resourceGroups/some-group/providers/Microsoft.Network\networkSecurityGroups\nsg',
          :description      => 'foo\bar'
        )

        migrate
        stack_resource.reload

        expect(stack_resource.ems_ref).to eql('/subscriptions/xyz/resourceGroups/some-group/providers/Microsoft.Network/networkSecurityGroups/nsg')
        expect(stack_resource.description).to eql('foo/bar')
      end
    end

    context "event streams" do
      it 'Converts backslashes to forward slashes in the vm_ems_ref column for event streams' do
        event_stream = event_stream_stub.create!(
          :vm_name    => 'foo',
          :vm_ems_ref => 'xyz\some_group\microsoft.compute/virtualmachines\foo',
          :source     => 'AZURE'
        )

        migrate
        event_stream.reload

        expect(event_stream.vm_ems_ref).to eql('xyz/some_group/microsoft.compute/virtualmachines/foo')
      end
    end
  end
end
