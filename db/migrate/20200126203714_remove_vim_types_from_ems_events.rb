class RemoveVimTypesFromEmsEvents < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  include MigrationHelper

  BATCH_SIZE = 5_000

  module VimType
    def vimType
      @vimType.nil? ? nil : @vimType.to_s
    end

    def vimType=(val)
      @vimType = val.nil? ? nil : val.to_sym
    end

    def xsiType
      @xsiType.nil? ? nil : @xsiType.to_s
    end

    def xsiType=(val)
      @xsiType = val.nil? ? nil : val.to_sym
    end
  end

  class VimHash < Hash; include VimType; end
  class VimArray < Array; include VimType; end
  class VimString < String; include VimType; end

  class EventStream < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    with_replaced_constants(:VimHash => VimHash, :VimString => VimString, :VimArray => VimArray) do
      say_with_time("Removing Vim Types from EmsEvents") do
        base_relation = EventStream.in_my_region.where(:source => "VC")
        say_batch_started(base_relation.size)

        processed_count = 0
        base_relation.find_each(batch_size: BATCH_SIZE) do |event|
          full_data = YAML.load(event.full_data)
          event.update!(:full_data => vim_types_to_basic_types(full_data).to_yaml)

          processed_count += 1
          if (processed_count % BATCH_SIZE).zero?
            say_batch_processed(processed_count)
            processed_count = 0
          end
        end
      end
    end
  end

  private

  def with_replaced_constants(constants)
    backed_up_constants = Hash[constants.map { |sym, klass| [sym, const_replace(sym, klass)] }]
    yield
  ensure
    backed_up_constants.each { |sym, klass| const_replace(sym, klass) }
  end

  def const_replace(const_name, new_const)
    old_const = const_remove(const_name)
    Object.const_set(const_name, new_const)
    old_const
  end

  def const_remove(const_name)
    return unless Object.const_defined?(const_name)

    Object.send(:remove_const, const_name)
  end

  def vim_types_to_basic_types(obj)
    case obj
    when VimString
      obj = obj.to_s
    when VimHash
      obj = obj.to_h
      obj.transform_values! { |val| vim_types_to_basic_types(val) }
    when VimArray
      obj = obj.to_a
      obj.map! { |v| vim_types_to_basic_types(v) }
    end

    obj
  end
end
