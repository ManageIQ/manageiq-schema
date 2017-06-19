def reserved_model(module_to_include)
  Class.new(ActiveRecord::Base) do
    def self.name
      "TestClass"
    end

    self.table_name = "vms"
    include module_to_include
  end
end
