require_migration

describe UpdateCustomButtonSets do
  let(:custom_button_set_stub) { migration_stub :MiqSet }
  let(:custom_button_stub) { migration_stub :CustomButton }

  migration_context :up do
    it 'Removes non-existing buttons while keeping the buttons sorted' do
      cb1 = custom_button_stub.create!(:id => 1)
      cb2 = custom_button_stub.create!(:id => 2)
      cb4 = custom_button_stub.create!(:id => 4)
      cb5 = custom_button_stub.create!(:id => 5)
      cb7 = custom_button_stub.create!(:id => 7)
      cbs = custom_button_set_stub.create!(
        :set_type => 'CustomButtonSet',
        :set_data => { :button_order => [
          cb1.id, cb7.id, cb2.id, cb4.id, 6, cb5.id, 3]})

      migrate

      cbs.reload
      expect(cbs.set_data[:button_order]).to eql([cb1.id, cb7.id, cb2.id, cb4.id, cb5.id])
    end
  end
end
