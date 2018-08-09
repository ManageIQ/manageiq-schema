require_migration

describe RemoveTransformationProductSetting do
  let(:settings_change_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "removes the /product/transformation key" do
      setting_changed = settings_change_stub.create!(:key => "/product/transformation", :value => true)
      setting_ignored = settings_change_stub.create!(:key => "/product/magic", :value => true)

      migrate

      expect { setting_changed.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(setting_ignored.reload.value).to eq(true)
    end
  end
end
