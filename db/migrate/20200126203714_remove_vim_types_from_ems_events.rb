class RemoveVimTypesFromEmsEvents < ActiveRecord::Migration[5.1]
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

  class VimHash < Hash
    include VimType
  end

  class VimArray < Array
    include VimType
  end

  class VimString < String
    include VimType
  end

  class EventStream < ActiveRecord::Base
    include ActiveRecord::IdRegions

    self.inheritance_column = :_type_disabled
  end

  def up
    vim_hash_backup   = const_replace(:VimHash, VimHash)
    vim_string_backup = const_replace(:VimString, VimString)
    vim_array_backup  = const_replace(:VimArray, VimArray)

    EventStream.in_my_region.where(:source => "VC").find_each do |event|
      full_data = YAML.load(event.full_data)
      event.update!(:full_data => vim_types_to_basic_types(full_data).to_yaml)
    end

    const_replace(:VimHash, vim_hash_backup)
    const_replace(:VimString, vim_string_backup)
    const_replace(:VimArray, vim_array_backup)
  end

  private

  def const_replace(const_name, new_const)
    old_const = const_remove(const_name)
    Object.const_set(const_name, new_const)
    old_const
  end

  def const_remove(const_name)
    return unless Object.const_defined?(const_name)
    old_const = Object.const_get(const_name)
    Object.send(:remove_const, const_name)
  end

  def vim_types_to_basic_types(obj)
    case obj
    when VimString
      obj = obj.to_s
    when VimHash
      obj = obj.to_h
      obj.each { |key, val| obj[key] = vim_types_to_basic_types(val) }
    when VimArray
      obj = obj.map { |v| vim_types_to_basic_types(v) }
    end

    obj
  end
end
