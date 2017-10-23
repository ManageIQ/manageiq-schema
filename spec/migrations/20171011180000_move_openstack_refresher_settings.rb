require_migration

describe MoveOpenstackRefresherSettings do
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it 'Move Openstack provider refresher settings' do
      settings_stub.create!(:key => '/ems/ems_openstack/refresh/inventory_object_refresh', :value => true)
      settings_stub.create!(:key => '/ems/ems_openstack/refresh/heat/is_global_admin', :value => true)
      settings_stub.create!(:key => '/ems/ems_openstack/refresh/is_admin', :value => true)
      settings_stub.create!(:key => '/ems/ems_openstack/refresh/event_targeted_refresh', :value => true)

      migrate

      expect(settings_stub.where(:key => '/ems/ems_refresh/openstack/inventory_object_refresh').count).to eq(1)
      expect(settings_stub.where(:key => '/ems/ems_refresh/openstack/heat/is_global_admin').count).to eq(1)
      expect(settings_stub.where(:key => '/ems/ems_refresh/openstack/is_admin').count).to eq(1)
      expect(settings_stub.where(:key => '/ems/ems_refresh/openstack/allow_targeted_refresh').count).to eq(1)
    end
  end
end
