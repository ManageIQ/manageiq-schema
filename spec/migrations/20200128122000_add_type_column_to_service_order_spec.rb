require_migration

describe AddTypeColumnToServiceOrder do
  let(:service_order) { migration_stub(:ServiceOrder) }
  let(:miq_request)   { migration_stub(:MiqRequest) }

  migration_context :up do
    it "Updates service orders to v2v or cart" do
      v2v_service_order = service_order.create!
      miq_request.create!(:type             => 'ServiceTemplateTransformationPlanRequest',
                          :service_order_id => v2v_service_order.id)
      plain_service_order = service_order.create!

      migrate

      v2v_service_order.reload
      expect(v2v_service_order.type).to eq "ServiceOrderV2V"

      plain_service_order.reload
      expect(plain_service_order.type).to eq "ServiceOrderCart"
    end
  end
end
