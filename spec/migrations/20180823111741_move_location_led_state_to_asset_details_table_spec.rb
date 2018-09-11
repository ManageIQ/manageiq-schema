require_migration

describe MoveLocationLedStateToAssetDetailsTable do
  let(:asset_detail_stub)     { migration_stub(:AssetDetail) }
  let(:physical_chassis_stub) { migration_stub(:PhysicalChassis) }
  let(:physical_server_stub)  { migration_stub(:PhysicalServer) }

  context "resources with asset detail" do
    migration_context :up do
      let!(:physical_chassis) { physical_chassis_stub.create!(:location_led_state => 'Blinking') }
      let!(:physical_server)  { physical_server_stub.create!(:location_led_state => 'Off') }

      it "should migrate the data from physical_chassis and physical_servers to asset_details table" do
        asset_detail_chassis = asset_detail_stub.create!(:resource_type => "PhysicalChassis", :resource_id => physical_chassis.id)
        asset_detail_server  = asset_detail_stub.create!(:resource_type => "PhysicalServer", :resource_id => physical_server.id)

        migrate

        expect(asset_detail_chassis.reload.location_led_state).to eq('Blinking')
        expect(asset_detail_server.reload.location_led_state).to  eq('Off')
      end

      it "should create associated asset_detail and migrate the data if it doesn't exist" do
        migrate

        expect(asset_detail_stub.find_by(:resource_type => "PhysicalChassis", :resource_id => physical_chassis.id)).to have_attributes(:location_led_state => 'Blinking')
        expect(asset_detail_stub.find_by(:resource_type => "PhysicalServer", :resource_id => physical_server.id)).to   have_attributes(:location_led_state => 'Off')
      end
    end

    migration_context :down do
      let!(:physical_chassis) { physical_chassis_stub.create! }
      let!(:physical_server)  { physical_server_stub.create! }

      it "should migrate the data back from asset_details to physical_chassis and physical_servers tables" do
        asset_detail_stub.create!(:location_led_state => 'Blinking', :resource_type => "PhysicalChassis", :resource_id => physical_chassis.id)
        asset_detail_stub.create!(:location_led_state => 'Off', :resource_type => "PhysicalServer", :resource_id => physical_server.id)

        migrate

        expect(physical_chassis.reload.location_led_state).to eq('Blinking')
        expect(physical_server.reload.location_led_state).to  eq('Off')
      end

      it "should migrate the data back from asset_details to physical_chassis and physical_servers tables" do
        migrate

        expect(physical_chassis.reload.location_led_state).to be_nil
        expect(physical_server.reload.location_led_state).to  be_nil
      end
    end
  end
end
