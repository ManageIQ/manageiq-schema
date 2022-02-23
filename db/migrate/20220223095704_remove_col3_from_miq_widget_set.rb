class RemoveCol3FromMiqWidgetSet < ActiveRecord::Migration[6.0]
  class MiqWidgetSet < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.table_name = "miq_sets"
    serialize :set_data
  end

  def up
    say_with_time("Moving col3 widgets to col2 and removing col3") do
      MiqWidgetSet.all.each do |item|
        data = item.set_data
        if data
          data[:col2] = ((data[:col2] || []) + (data[:col3] || [])).uniq.compact
          item.update(:set_data => data.except(:col3))
        end
      end
    end
  end

  def down
    say_with_time("Adding col3 to widgets and assigining blank to it") do
      MiqWidgetSet.all.each do |item|
        data = item.set_data
        if data
          data[:col3] = []
          item.update(:set_data => data)
        end
      end
    end
  end
end
