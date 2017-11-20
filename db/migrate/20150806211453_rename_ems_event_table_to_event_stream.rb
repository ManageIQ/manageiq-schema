class RenameEmsEventTableToEventStream < ActiveRecord::Migration[4.2]
  disable_ddl_transaction!
  include MigrationHelper

  BATCH_SIZE = 25_000

  class EventStream < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class EmsEvent < ActiveRecord::Base; end

  def up
    rename_table :ems_events, :event_streams

    add_column :event_streams, :type, :string
    say_with_time("Updating Type in EventStreams") do
      base_relation = EventStream.where(:type => nil)
      say_batch_started(base_relation.size)

      loop do
        count = base_relation.limit(BATCH_SIZE).update_all(:type => 'EmsEvent')
        break if count == 0
        say_batch_processed(count)
      end
    end

    change_table :event_streams do |t|
      t.references :target, :polymorphic => true, :type => :bigint
    end
  end

  def down
    remove_column :event_streams, :type

    change_table :event_streams do |t|
      t.remove_references :target, :polymorphic => true
    end

    rename_table :event_streams, :ems_events
  end
end
