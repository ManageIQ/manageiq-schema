require_migration

describe AddCoresAllocatedRateDetail do
  let(:rate_stub) { migration_stub(:ChargebackRate) }
  let(:detail_stub) { migration_stub(:ChargebackRateDetail) }
  let(:field_stub) { migration_stub(:ChargeableField) }
  let(:measure_stub) { migration_stub(:ChargebackRateDetailMeasure) }

  let(:default_rate) { rate_stub.create!(:rate_type => 'Compute', :default => :true) }
  let(:custom_rate) { rate_stub.create!(:rate_type => 'Compute') }

  let(:rate_details) do
    [
      {:metric => 'cpu_usagemhz_rate_average', :group => 'cpu', :source => 'used', :description => 'Used CPU'},
      {:metric => 'derived_vm_numvcpus', :group => 'cpu', :source => 'allocated', :description => 'Allocated CPU Count'},
      {:metric => 'disk_usage_rate_average', :group => 'disk_io', :source => 'used', :description => 'Used Disk I/O'}
    ]
  end

  let(:allocated_cores) { {:metric => 'derived_vm_numvcpus_cores', :group => 'cpu cores', :source => 'allocated', :description => 'Allocated CPU Cores'} }

  migration_context :up do
    it 'Adds a "Allocated CPU Cores" rate detail to existing details' do
      rate_details.each do |field|
        detail_stub.create!(field.merge(:chargeback_rate_id => default_rate.id))
        detail_stub.create!(field.merge(:chargeback_rate_id => custom_rate.id))
      end

      migrate

      expect(default_rate.reload.chargeback_rate_details.where(:description => "Allocated CPU Cores").count).to eq(1)
      expect(custom_rate.reload.chargeback_rate_details.where(:description => "Allocated CPU Cores").count).to eq(1)
    end
  end

  migration_context :down do
    it 'Removes all "Allocated CPU Cores" rate details' do
      detail_stub.create!(allocated_cores.merge(:chargeback_rate_id => default_rate.id))
      detail_stub.create!(allocated_cores.merge(:chargeback_rate_id => custom_rate.id))

      migrate

      expect(detail_stub.where(:description => "Allocated CPU Cores").count).to eq(0)
    end
  end
end
