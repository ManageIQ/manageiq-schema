module ReservedMigrationMixin
  extend ActiveSupport::Concern

  include ReservedSharedMixin

  # Migrate values from the reserved hash to a column.  Accepts either
  #   an Array of key names when the column names match the key names, or
  #   a Hash of key names to column names if the column names do not match the
  #   key names
  def reserved_hash_migrate(*keys)
    keys = keys.flatten
    if keys.last.kind_of?(Hash)
      keys = keys.last
    else
      keys = keys.zip(keys) # [:key1, :key2] => [[:key1, :key1], [:key2, :key2]]
    end

    keys.each do |key, attribute|
      val = reserved_hash_get(key)
      reserved_hash_set(key, nil)
      send("#{attribute}=", val)
    end
    self.save!
  end
end
