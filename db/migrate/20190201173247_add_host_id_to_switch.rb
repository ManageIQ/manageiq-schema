class AddHostIdToSwitch < ActiveRecord::Migration[5.0]
  def change
    add_reference :switches, :host, :type => :bigint, :index => true
  end
end
