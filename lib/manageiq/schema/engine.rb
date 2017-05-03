module Manageiq
  module Schema
    class Engine < ::Rails::Engine
      isolate_namespace Manageiq::Schema
    end
  end
end
