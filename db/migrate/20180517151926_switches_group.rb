class SwitchesGroup < ActiveRecord::Migration[5.0]
  class PhysicalSwitches < ActiveRecord::Base
    self.table_name = 'switches'
  end
end
