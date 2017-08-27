require_migration

describe ChangeContainerQuotaItemsColumnsToFloat do
  let(:container_quota_item_stub) { migration_stub(:ContainerQuotaItem) }

  migration_context :up do
    it "converts string quotas to float values" do
      quota_item = container_quota_item_stub.create!(:quota_desired  => "10m",
                                                     :quota_enforced => "2Gi",
                                                     :quota_observed => "30Mi")

      migrate

      quota_item.reload
      expect(quota_item.reload).to have_attributes(:quota_desired  => 0.01,
                                                   :quota_enforced => 2_147_483_648,
                                                   :quota_observed => 31_457_280)
    end

    it "converts big integers (under 2^49) to float values without rounding" do
      big_int = 2**49
      quota_item = container_quota_item_stub.create!(:quota_desired => big_int.to_s)

      migrate

      quota_item.reload
      expect(quota_item.quota_desired).to eq(big_int)
    end
  end

  migration_context :down do
    it "converts float values to string quotas" do
      quota_item = container_quota_item_stub.create!(:quota_desired  => 0.01,
                                                     :quota_enforced => 1.0,
                                                     :quota_observed => 1.5)

      migrate

      quota_item.reload
      expect(quota_item.reload).to have_attributes(:quota_desired  => "0.01",
                                                   :quota_enforced => "1",
                                                   :quota_observed => "1.5")
    end
  end
end
