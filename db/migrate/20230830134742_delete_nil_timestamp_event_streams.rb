class DeleteNilTimestampEventStreams < ActiveRecord::Migration[6.1]
  class EventStream < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Deleting event_streams with nil timestamp values") do
      EventStream.where(:timestamp => nil).delete_all
    end
  end
end
