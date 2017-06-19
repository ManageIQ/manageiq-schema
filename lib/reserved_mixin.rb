module ReservedMixin
  extend ActiveSupport::Concern

  include ReservedSharedMixin

  module ClassMethods
    # Dynamically creates a getter, setter, and ? method that uses the
    #   reserved column as a Hash to store the value.
    def reserve_attribute(name, type)
      name = name.to_sym

      attribute name, type

      define_method(name)       { reserved_hash_get(name) }
      define_method("#{name}?") { !!reserved_hash_get(name) }
      define_method("#{name}=") do |val|
        send("#{name}_will_change!")
        reserved_hash_set(name, val)
      end
    end
  end
end
