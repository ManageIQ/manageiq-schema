require_migration

describe RemoveAmazonCustomInstanceTypes do
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it 'Remove /ems/ems_amazon/additional_instance_types/* defined also in instance_types.rb' do
      settings_stub.create!(:key => '/ems/ems_amazon/additional_instance_types/dup_type/name', :value => "f2.2xfake")
      settings_stub.create!(:key => '/ems/ems_amazon/additional_instance_types/dup_type/family', :value => "Fake type 2")

      settings_stub.create!(:key => '/ems/ems_amazon/additional_instance_types/my_type/name', :value => "f3.2xfake")
      settings_stub.create!(:key => '/ems/ems_amazon/additional_instance_types/my_type/family', :value => "Fake type 3")

      stub_const("InstanceTypes::AVAILABLE_TYPES", "dup_type" => {})
      migrate

      expect(settings_stub.where('key LIKE ?', '/ems/ems_amazon/additional_instance_types/dup_type/%')).to be_empty
      expect(settings_stub.where('key LIKE ?', '/ems/ems_amazon/additional_instance_types/my_type/%').count).to eq(2)
    end
  end
end
