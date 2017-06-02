module ManageIQ
  module Schema
    class Engine < ::Rails::Engine
      isolate_namespace ManageIQ::Schema
    end
  end
end
