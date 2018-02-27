require_migration

describe RemoveHawkularEms do
  let(:ems_stub) { migration_stub :ExtManagementSystem }

  migration_context :up do
    before do
      ems_stub.create!(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager',
                       :name => 'bad')
      ems_stub.create!(:type => 'ManageIQ::Providers::Redhat::InfraManager',
                       :name => 'good_1')
      ems_stub.create!(:type => 'ManageIQ::Providers::Openshift::ContainerManager',
                       :name => 'good_2')
      ems_stub.create!(:type => 'ManageIQ::Providers::Amazon::NetworkManager',
                       :name => 'good_3')

      migrate
    end

    it "deletes hawkular records" do
      expect(ems_stub.pluck(:name)).not_to include('bad')
    end

    it "doesn't delete unrelated records" do
      expect(ems_stub.pluck(:name).sort).to eq(%w(good_1 good_2 good_3))
    end
  end
end
