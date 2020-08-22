module ManageIQ
  module Schema
    module CommandRecorder
      def add_trigger(*args)
        record(:add_trigger, args)
      end

      def drop_trigger(*args)
        record(:drop_trigger, args)
      end
    end
  end
end
