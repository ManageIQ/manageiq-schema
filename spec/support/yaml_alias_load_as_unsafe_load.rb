if Psych::VERSION >= "4.0"
  require 'yaml'
  YAML.singleton_class.alias_method :load, :unsafe_load
end
