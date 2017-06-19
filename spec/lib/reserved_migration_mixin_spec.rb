describe ReservedMigrationMixin do
  let(:test_class) { reserved_model(described_class) }

  context "#reserved_hash_migrate" do
    before(:each) do
      @t = test_class.create
    end

    context "when the reserved key name matches the column name" do
      it "with a single key" do
        Reserve.create!(:resource => @t, :reserved => {:name => "test"})
        @t.reload

        @t.reserved_hash_migrate(:name)

        expect(Reserve.count).to eq(0)
        expect(@t.name).to eq("test")
      end

      it "with multiple keys" do
        Reserve.create!(:resource => @t, :reserved => {:name => "test", :description => "test2"})
        @t.reload

        @t.reserved_hash_migrate(:name, :description)

        expect(Reserve.count).to eq(0)
        expect(@t.name).to eq("test")
        expect(@t.description).to eq("test2")
      end
    end

    context "when the reserved key name does not match the column name" do
      it "with a single key" do
        Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
        @t.reload

        @t.reserved_hash_migrate(:some_field => :name)

        expect(Reserve.count).to eq(0)
        expect(@t.name).to eq("test")
      end

      it "with multiple keys" do
        Reserve.create!(:resource => @t, :reserved => {:some_field => "test", :another_field => "test2"})
        @t.reload

        @t.reserved_hash_migrate(:some_field => :name, :another_field => :description)

        expect(Reserve.count).to eq(0)
        expect(@t.name).to eq("test")
        expect(@t.description).to eq("test2")
      end
    end
  end
end
