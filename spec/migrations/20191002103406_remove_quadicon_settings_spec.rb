require_migration

describe RemoveQuadiconSettings do
  migration_context :up do
    let(:user_stub) { migration_stub(:User) }

    it "removes the quadicon from user settings" do
      u = user_stub.create!(:settings => { :quadicons => { :foo => :bar }, :foo => :bar })

      expect(u.settings[:quadicons]).not_to be_nil

      migrate

      expect(u.reload.settings[:quadicons]).to be_nil
      expect(u.settings[:foo]).to eq(:bar)
    end

    it "doesn't affect users without a quadicon setting" do
      u = user_stub.create!(:settings => { :foo => :bar })

      migrate

      expect(u.reload.settings[:foo]).to eq(:bar)
    end
  end
end
