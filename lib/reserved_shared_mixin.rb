module ReservedSharedMixin
  extend ActiveSupport::Concern

  included do
    has_one :reserved_rec, :class_name => "::Reserve", :as => :resource,
      :autosave => true, :dependent => :delete
  end

  def reserved_hash_get(key)
    res = reserved
    res && res[key]
  end

  def reserved_hash_set(key, val)
    res = (reserved || {})
    if val.nil?
      res.delete(key)
    else
      res[key] = val
    end
    self.reserved = res
    val
  end

  def reserved
    reserved_rec.try(:reserved)
  end

  def reserved=(val)
    res = reserved_rec
    if val.blank?
      self.reserved_rec = nil
    elsif res.nil?
      build_reserved_rec(:reserved => val)
    else
      res.reserved = val
    end
    val
  end
end
