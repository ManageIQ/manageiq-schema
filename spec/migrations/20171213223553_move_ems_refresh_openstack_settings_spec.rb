require_migration

describe MoveEmsRefreshOpenstackSettings do
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it 'Move ems_refresh Openstack provider refresher settings under the root' do
      settings_stub.create!(:key => '/ems/ems_refresh/openstack/inventory_object_refresh', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack/heat/is_global_admin', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack/is_admin', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack/allow_targeted_refresh', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack_network/inventory_object_refresh', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack_network/is_admin', :value => true)
      settings_stub.create!(:key => '/ems/ems_refresh/openstack_network/allow_targeted_refresh', :value => true)

      migrate

      expect(settings_stub.where(:key => '/ems_refresh/openstack/inventory_object_refresh').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack/heat/is_global_admin').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack/is_admin').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack/allow_targeted_refresh').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack_network/inventory_object_refresh').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack_network/is_admin').count).to eq(1)
      expect(settings_stub.where(:key => '/ems_refresh/openstack_network/allow_targeted_refresh').count).to eq(1)
    end
  end
end
