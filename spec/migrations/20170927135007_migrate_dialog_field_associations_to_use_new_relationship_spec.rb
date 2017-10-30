require_migration

describe MigrateDialogFieldAssociationsToUseNewRelationship do
  let(:dialog_field_stub) { migration_stub(:DialogField) }
  let(:dialog_group_stub) { migration_stub(:DialogGroup) }
  let(:dialog_tab_stub) { migration_stub(:DialogTab) }
  let(:dialog_stub) { migration_stub(:Dialog) }
  let(:dialog_field_association_stub) { migration_stub(:DialogFieldAssociation) }
  let(:dialog_group_id) { dialog_group_stub.first.id }
  let(:dialog_tab_id) { dialog_tab_stub.first.id }
  let(:dialog_id) { dialog_stub.first.id }

  migration_context :up do
    before do
      dialog_stub.create!
      dialog_tab_stub.create!(:dialog_id => dialog_id, :position => 4)
      dialog_group_stub.create!(:dialog_tab_id => dialog_tab_id, :position => 7)
    end

    it "does not create a reference when trigger field is after responder field" do
      dialog_field_stub.create!(:name => "dialog_field4", :auto_refresh => true, :position => 0, :dialog_group_id => dialog_group_id, :type => "DialogFieldTextbox")
      dialog_field_stub.create!(:name => "dialog_field1", :trigger_auto_refresh => true, :position => 4, :dialog_group_id => dialog_group_id, :type => "DialogFieldDropdown")
      expect(dialog_field_association_stub.count).to eq(0)

      migrate

      expect(dialog_field_association_stub.count).to eq(0)
    end

    it "does not create a circular reference" do
      dialog_field_stub.create!(:name => "dialog_field4", :trigger_auto_refresh => true, :auto_refresh => true, :position => 0, :dialog_group_id => dialog_group_id, :type => "DialogFieldRadioButton")
      dialog_field_stub.create!(:name => "dialog_field1", :auto_refresh => true, :trigger_auto_refresh => true, :position => 4, :dialog_group_id => dialog_group_id, :type => "DialogFieldTagControl")
      expect(dialog_field_association_stub.count).to eq(0)

      migrate

      expect(dialog_field_association_stub.count).to eq(1)
      expect(dialog_field_association_stub.first.trigger_id).to eq(dialog_field_stub.first.id)
      expect(dialog_field_association_stub.first.respond_id).to eq(dialog_field_stub.second.id)
    end

    it "does create a reference when valid one is present" do
      dialog_field_stub.create!(:name => "dialog_field4", :auto_refresh => true, :position => 2, :dialog_group_id => dialog_group_id)
      dialog_field_stub.create!(:name => "dialog_field1", :trigger_auto_refresh => true, :position => 0, :dialog_group_id => dialog_group_id)
      expect(dialog_field_association_stub.count).to eq(0)

      migrate

      expect(dialog_field_association_stub.count).to eq(1)
      expect(dialog_field_association_stub.first.trigger_id).to eq(dialog_field_stub.second.id)
      expect(dialog_field_association_stub.first.respond_id).to eq(dialog_field_stub.first.id)
    end

    it "does not create association when dialog tab is missing" do
      dialog_tab_stub.delete_all
      dialog_field_stub.create!(:name => "dialog_field4", :auto_refresh => true, :position => 2, :dialog_group_id => dialog_group_stub.first.id)
      dialog_field_stub.create!(:name => "dialog_field1", :trigger_auto_refresh => true, :position => 0, :dialog_group_id => dialog_group_stub.first.id)
      expect(dialog_field_association_stub.count).to eq(0)

      migrate

      expect(dialog_field_association_stub.count).to eq(0)
    end

    it "only creates dialog associations if the fields are on the same dialog" do
      dialog_field_stub.create!(:name => "dialog_field4", :trigger_auto_refresh => true, :position => 4, :dialog_group_id => dialog_group_stub.first.id, :type => "DialogFieldDateControl")

      expect(dialog_field_association_stub.count).to eq(0)

      migrate

      expect(dialog_field_association_stub.count).to eq(0)
    end
  end

  migration_context :down do
    it "should delete dialog field associations" do
      dialog_field_stub.create!(:name => "dialog_field6")
      dialog_field_stub.create!(:name => "dialog_field9")
      dialog_field_association_stub.create!(:trigger_id => dialog_field_stub.first.id, :respond_id => dialog_field_stub.second.id)

      expect(dialog_field_association_stub.count).to eq(1)

      migrate

      expect(dialog_field_association_stub.count).to eq(0)
    end
  end
end
