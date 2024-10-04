module Dummy
  module SerializePositionalToKwargsBridge
    def serialize(*args, **options)
      return super if Rails.version >= "7.1"

      # For rails 7.0.x, convert 7.1+ kwargs for coder/type into the positional argument
      # class_name_or_coder
      if options[:coder]
        args << options.delete(:coder)
      elsif options[:type]
        args << options.delete(:type)
      end

      super(*args, **options)
    end
  end
end

ActiveRecord::AttributeMethods::Serialization::ClassMethods.send(:prepend, Dummy::SerializePositionalToKwargsBridge)
