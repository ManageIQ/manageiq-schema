module ManageIQ
  module Schema
    module CommandRecorder
      def add_trigger(*args)
        record(:add_trigger, args)
      end

      def drop_trigger(*args)
        record(:drop_trigger, args)
      end

      def create_view(*args)
        record(:create_view, args)
      end

      def drop_view(*args)
        record(:drop_view, args)
      end
    end
  end
end
