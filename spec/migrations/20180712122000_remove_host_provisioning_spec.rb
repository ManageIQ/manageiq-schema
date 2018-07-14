require_migration

describe RemoveHostProvisioning do
  migration_context :up do
    let(:miq_request_stub) { migration_stub :MiqRequest }
    let(:miq_request_task_stub) { migration_stub :MiqRequestTask }
    let(:miq_approval_stub) { migration_stub :MiqApproval }

    it 'only removes Host Provision request instances' do
      miq_request_stub.create!(:type => 'MiqProvisionRequest', :miq_approvals => [miq_approval_stub.create!])
      miq_request_stub.create!(:type => 'MiqHostProvisionRequest', :miq_approvals => [miq_approval_stub.create!])
      miq_request_stub.create!(:type => 'ServiceTemplateProvisionRequest', :miq_approvals => [miq_approval_stub.create!])

      miq_request_task_stub.create!(:type => 'MiqProvision')
      miq_request_task_stub.create!(:type => 'MiqHostProvision')
      miq_request_task_stub.create!(:type => 'ServiceTemplateProvisionTask')

      migrate

      expect(miq_request_stub.count).to eq 2
      expect(miq_request_task_stub.count).to eq 2
      expect(miq_approval_stub.count).to eq 2
    end
  end
end
