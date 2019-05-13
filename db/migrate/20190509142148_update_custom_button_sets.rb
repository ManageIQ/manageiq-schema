class UpdateCustomButtonSets < ActiveRecord::Migration[5.0]
  class MiqSet < ActiveRecord::Base
    serialize :set_data
  end

  class CustomButton < ActiveRecord::Base; end

  def up
    say_with_time("Removing deleted buttons from Custom Button Sets") do
      MiqSet.select(:id, :set_data).where(:set_type => 'CustomButtonSet').each do |cbs|
        next if cbs.set_data[:button_order].blank?
        existing_buttons = CustomButton
          .where(:id => cbs.set_data[:button_order])
          .order("position(id::text in '#{cbs.set_data[:button_order].join(',')}')")
          .ids
        cbs.set_data[:button_order] = existing_buttons
        cbs.save!
      end
    end
  end
end
