module Spec
  module Support
    module ConstantWatcher
      mattr_accessor :classes_by_file

      def inherited(other)
        Spec::Support::ConstantWatcher.add(other)
        super
      end

      def self.add(const)
        path = caller_locations(2..2).first.path
        self.classes_by_file ||= {}
        self.classes_by_file[path] ||= []
        self.classes_by_file[path] << const.name
      end
    end
  end
end

ActiveRecord::Base.singleton_class.prepend(Spec::Support::ConstantWatcher)
