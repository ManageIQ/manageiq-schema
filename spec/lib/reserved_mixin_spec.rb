describe ReservedMixin do
  let(:test_class) do
    reserved_model(described_class).tap do |m|
      m.reserve_attribute :some_field, :string
    end
  end

  context ".reserve_attribute" do
    it "normal case" do
      t = test_class.new
      expect(t).to respond_to(:some_field)
      expect(t).to respond_to(:some_field?)
      expect(t).to respond_to(:some_field=)

      t.some_field = "test"
      expect(t.some_field).to eq("test")
      expect(t.some_field?).to be_truthy

      t.some_field = nil
      expect(t.some_field).to  be_nil
      expect(t.some_field?).to be_falsey
    end

    it "with multiple fields" do
      reserved_attributes = Module.new do
        def self.included(klass)
          klass.reserve_attribute :another_field, :string
          klass.reserve_attribute :a_third_field, :string
        end
      end
      test_class.include(reserved_attributes)

      t = test_class.new
      expect(t).to respond_to(:another_field)
      expect(t).to respond_to(:another_field?)
      expect(t).to respond_to(:another_field=)
      expect(t).to respond_to(:a_third_field)
      expect(t).to respond_to(:a_third_field?)
      expect(t).to respond_to(:a_third_field=)
    end
  end

  context "#save" do
    context "will touch the parent record's updated_on" do
      before(:each) do
        @t = test_class.create
        @last_update = @t.updated_on
      end

      it "without existing reserved data" do
        @t.update_attribute(:some_field, "test")
        expect(@t.updated_on).not_to eq(@last_update)
      end

      context "with existing reserved data" do
        before(:each) do
          Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
          @t.reload
        end

        it "and data changing" do
          @t.update_attribute(:some_field, "test2")
          expect(@t.updated_on).not_to eq(@last_update)
        end
      end
    end
  end
end
