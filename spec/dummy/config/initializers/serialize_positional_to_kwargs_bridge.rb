module Dummy
  module SerializePositionalToKwargsBridge
    def serialize(*args, **options)
      return super if Rails.version < "7.1" || options[:coder]

      # If class_name_or_coder second argument is a class, set the type
      if args[1].respond_to?(:new)
        options = options.merge(coder: YAML, type: args[1])
      # If no class or coder provided, assume YAML coder and Object (legacy defaults / no validation)
      elsif args[1].blank?
        options = options.merge(coder: YAML, type: Object)
      else
        # otherwise, it's a coder which should only define dump/load, so set coder
        options = options.merge(coder: args[1], type: Object)
      end

      # pass the first argument (drop the second) and forward the updated kwargs
      super(args[0], **options)
    end
  end
end

ActiveRecord::AttributeMethods::Serialization::ClassMethods.send(:prepend, Dummy::SerializePositionalToKwargsBridge)
