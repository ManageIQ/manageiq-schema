require_migration

describe RemoveCol3FromMiqWidgetSet do
  let(:widget_stub) { migration_stub(:MiqWidgetSet) }

  migration_context :up do
    it "Moving col3 widgets to col2 and removing col3" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6], :col3 => [7, 8, 9]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6, 7, 8, 9]})
    end

    it "Avoiding duplicate widgets after joining col3 with col2" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6, 7, 8], :col3 => [4, 7, 8, 9]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6, 7, 8, 9]})
    end

    it "Moving col3 widget to col2 when col3 is not present" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end

    it "Moving col3 widget to col2 when col2 is not present" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col3 => [4, 5, 6]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end

    it "Moving col3 with nil data to col2" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6], :col3 => nil})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end

    it "Moving col3 to col2 where col2 is nil" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => nil, :col3 => [4, 5, 6]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end

    it "Moving col3 with blank data to col2" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6], :col3 => []})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end

    it "Moving col3 to col2 when col2 is blank" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [], :col3 => [4, 5, 6]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6]})
    end
  end

  migration_context :down do
    it "Adding col3 to widgets and assigining blank to it" do
      widget = widget_stub.create(:set_data => {:col1 => [1, 2, 3], :col2 => [4, 5, 6, 7, 8, 9]})
      migrate
      expect(widget.reload.set_data).to eq({:col1 => [1, 2, 3], :col2 => [4, 5, 6, 7, 8, 9], :col3 => []})
    end
  end
end
