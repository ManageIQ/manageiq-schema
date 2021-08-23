require_migration

describe ClassificationParentNull do
  let(:parent_id) { id_in_current_region(1) }
  let(:classification_stub) { migration_stub(:Classification) }

  migration_context :up do
    it 'changes parent to nil when parent is 0' do
      c = classification_stub.create(:parent_id => 0) # manageiq:disable HardcodedIds
      migrate
      c.reload
      expect(c.parent_id).to be_nil
    end

    it 'leaves other parents alone' do
      c = classification_stub.create(:parent_id => parent_id)
      migrate
      c.reload
      expect(c.parent_id).to eq(parent_id)
    end
  end

  migration_context :down do
    it 'changes parent to 0 when parent is null' do
      c = classification_stub.create(:parent_id => nil)
      migrate
      c.reload
      expect(c.parent_id).to eq(0)
    end
  end
end
