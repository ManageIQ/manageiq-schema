require_migration

describe ConvertGroupDescriptionsToIdsInVisibility do
  let(:miq_widget_stub)      { migration_stub(:MiqWidget) }
  let(:miq_group_stub)       { migration_stub(:MiqGroup) }

  let(:all_groups)           { ["_ALL_"] }
  let(:group_desc_1)         { "EvmGroup-super_administrator" }
  let(:group_desc_2)         { "EvmGroup-administrator" }
  let(:invalid_group_desc_1) { "NonExistentGroup" }
  let(:invalid_group_desc_2) { "AnotherMissingGroup" }

  migration_context :up do
    it "converts group descriptions to IDs for MiqWidget" do
      group1 = miq_group_stub.create!(:description => group_desc_1)
      group2 = miq_group_stub.create!(:description => group_desc_2)

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [group_desc_1, group_desc_2]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to match_array([group1.id, group2.id])
    end

    it "returns empty array when group descriptions don't exist" do
      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [invalid_group_desc_1, invalid_group_desc_2]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to eq([])
    end

    it "keeps valid groups when some are missing" do
      group1 = miq_group_stub.create!(:description => group_desc_1)

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [group_desc_1, invalid_group_desc_1]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to eq([group1.id])
    end

    it "preserves _ALL_ visibility" do
      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => all_groups}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to eq(all_groups)
    end

    it "skips records with no visibility" do
      widget = miq_widget_stub.create!(:title => "Test Widget")

      migrate

      expect(widget.reload.visibility).to eq({})
    end

    it "handles mixed group IDs and descriptions" do
      group1 = miq_group_stub.create!(:description => group_desc_1)
      group2 = miq_group_stub.create!(:description => group_desc_2)

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [group1.id, group_desc_2]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to match_array([group1.id, group2.id])
    end
  end

  migration_context :down do
    it "converts group IDs back to descriptions for MiqWidget" do
      group1 = miq_group_stub.create!(:description => group_desc_1)
      group2 = miq_group_stub.create!(:description => group_desc_2)

      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [group1.id, group2.id]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to match_array([group_desc_1, group_desc_2])
    end

    it "returns empty array when group IDs don't exist" do
      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => [999, 998]}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to eq([])
    end

    it "preserves _ALL_ visibility" do
      widget = miq_widget_stub.create!(
        :title      => "Test Widget",
        :visibility => {:groups => all_groups}
      )

      migrate

      expect(widget.reload.visibility[:groups]).to eq(all_groups)
    end
  end
end
