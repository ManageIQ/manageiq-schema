describe ReservedSharedMixin do
  let(:test_class) { reserved_model(described_class) }

  context "#reserved" do
    before(:each) do
      @t = test_class.create
    end

    it "without existing reserved data" do
      expect(@t.reserved).to be_nil
    end

    it "with existing reserved data" do
      Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
      @t.reload

      expect(@t.reserved).to eq({:some_field => "test"})
    end
  end

  context "#reserved=" do
    before(:each) do
      @t = test_class.create
    end

    context "to a non-empty Hash" do
      it "without existing reserved data" do
        @t.reserved = {:some_field => "test"}
        @t.save!

        expect(Reserve.count).to eq(1)
        expect(Reserve.first).to have_attributes(
          :resource_type => @t.class.name,
          :resource_id   => @t.id,
          :reserved      => {:some_field => "test"}
        )
      end

      it "with existing reserved data" do
        Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
        @t.reload

        @t.reserved = {:some_field => "test2"}
        @t.save!

        expect(Reserve.count).to eq(1)
        expect(Reserve.first).to have_attributes(
          :resource_type => @t.class.name,
          :resource_id   => @t.id,
          :reserved      => {:some_field => "test2"}
        )
      end
    end

    context "to an empty Hash" do
      it "without existing reserved data" do
        @t.reserved = {}
        @t.save!

        expect(Reserve.count).to eq(0)
      end

      it "with existing reserved data" do
        Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
        @t.reload

        @t.reserved = {}
        @t.save!

        expect(Reserve.count).to eq(0)
      end
    end

    context "to nil" do
      it "without existing reserved data" do
        @t.reserved = nil
        @t.save!

        expect(Reserve.count).to eq(0)
      end

      it "with existing reserved data" do
        Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
        @t.reload

        @t.reserved = nil
        @t.save!

        expect(Reserve.count).to eq(0)
      end
    end
  end

  context "#reserved_hash_get" do
    before(:each) do
      @t = test_class.create
    end

    it "without existing reserved data" do
      expect(@t.reserved_hash_get(:some_field)).to    be_nil
      expect(@t.reserved_hash_get(:another_field)).to be_nil
    end

    it "with existing reserved data" do
      Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
      @t.reload

      expect(@t.reserved_hash_get(:some_field)).to eq("test")
      expect(@t.reserved_hash_get(:another_field)).to be_nil
    end
  end

  context "#reserved_hash_set" do
    before(:each) do
      @t = test_class.create
    end

    context "to a non-nil value" do
      it "without existing reserved data" do
        @t.reserved_hash_set(:some_field, "test")
        @t.save!

        expect(Reserve.count).to eq(1)
        expect(Reserve.first).to have_attributes(
          :resource_type => @t.class.name,
          :resource_id   => @t.id,
          :reserved      => {:some_field => "test"}
        )
      end

      context "with existing reserved data" do
        before(:each) do
          Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
          @t.reload
        end

        it "updating an existing value" do
          @t.reserved_hash_set(:some_field, "test2")
          @t.save!

          expect(Reserve.count).to eq(1)
          expect(Reserve.first).to have_attributes(
            :resource_type => @t.class.name,
            :resource_id   => @t.id,
            :reserved      => {:some_field => "test2"}
          )
        end

        it "adding a new value" do
          @t.reserved_hash_set(:another_field, "test2")
          @t.save!

          expect(Reserve.count).to eq(1)
          expect(Reserve.first).to have_attributes(
            :resource_type => @t.class.name,
            :resource_id   => @t.id,
            :reserved      => {:some_field => "test", :another_field => "test2"}
          )
        end
      end
    end

    context "to nil" do
      it "without existing reserved data" do
        @t.reserved_hash_set(:some_field, nil)
        @t.save!

        expect(Reserve.count).to eq(0)
      end

      context "with existing reserved data" do
        it "of only this attribute" do
          Reserve.create!(:resource => @t, :reserved => {:some_field => "test"})
          @t.reload

          @t.reserved_hash_set(:some_field, nil)
          @t.save!

          expect(Reserve.count).to eq(0)
        end

        it "of multiple attributes" do
          Reserve.create!(:resource => @t, :reserved => {:some_field => "test", :another_field => "test2"})
          @t.reload

          @t.reserved_hash_set(:some_field, nil)
          @t.save!

          expect(Reserve.count).to eq(1)
          expect(Reserve.first).to have_attributes(
            :resource_type => @t.class.name,
            :resource_id   => @t.id,
            :reserved      => {:another_field => "test2"}
          )
        end
      end
    end
  end
end
