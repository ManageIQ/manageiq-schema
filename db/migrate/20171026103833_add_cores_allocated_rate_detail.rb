class AddCoresAllocatedRateDetail < ActiveRecord::Migration[5.0]
  class ChargebackRate < ActiveRecord::Base
    has_many :chargeback_rate_details, :class_name => 'AddCoresAllocatedRateDetail::ChargebackRateDetail'
  end

  class ChargebackTier < ActiveRecord::Base
    FORM_ATTRIBUTES = %i(fixed_rate variable_rate start finish).freeze
  end

  class ChargeableField < ActiveRecord::Base; end

  class ChargebackRateDetail < ActiveRecord::Base
    belongs_to :chargeback_rate, :class_name => 'AddCoresAllocatedRateDetail::ChargebackRate'
    belongs_to :chargeable_field
    has_many   :chargeback_tiers, :class_name => 'AddCoresAllocatedRateDetail::ChargebackTier'
  end

  def up
    rate_detail_template = ChargebackRateDetail.where(:description => "Allocated CPU Count").first
    return if rate_detail_template.nil? # No rates that need this detail.
    rate_detail_template = rate_detail_template.dup

    chargeable_field = ChargeableField.find_or_create_by(:metric      => "derived_vm_numvcpu_cores",
                                                         :description => "Allocated CPU Cores",
                                                         :group       => "cpu_cores",
                                                         :source      => "allocated")

    rate_detail_template.chargeable_field = chargeable_field
    rate_detail_template.description = "Allocated CPU Cores"
    rate_detail_template.per_unit = "cpu core"
    tier_template = {:start => 0, :finish => Float::INFINITY, :fixed_rate => 1.0, :variable_rate => 0.0}

    # Add to cb rates that do not have the "Allocated CPU Cores" cb detail
    ChargebackRate.where(:rate_type => "Compute").where.not(:id => ChargebackRateDetail.where(:description => "Allocated CPU Cores").select(:chargeback_rate_id)).each do |rate|
      new_rate_detail = rate_detail_template.dup
      new_rate_detail.chargeback_tiers << ChargebackTier.new(tier_template.slice(*ChargebackTier::FORM_ATTRIBUTES))
      rate.chargeback_rate_details << new_rate_detail
    end
  end

  def down
    ChargebackRateDetail.where(:description => "Allocated CPU Cores").destroy_all
  end
end
