class MoveBecomeMethodFromOptions < ActiveRecord::Migration[6.0]
  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    serialize :options
  end

  def up
    say_with_time("Move Authentication become_method out of options text field") do
      Authentication.in_my_region.find_each do |authentication|
        next unless authentication.options&.key?(:become_method)

        authentication.become_method = authentication.options.delete(:become_method)
        authentication.save!
      end
    end
  end

  def down
    say_with_time("Move Authentication become_method back to options text field") do
      Authentication.in_my_region.where.not(:become_method => nil).find_each do |authentication|
        authentication.options = {} if authentication.options.nil?
        authentication.options[:become_method] = authentication.become_method
        authentication.save!
      end
    end
  end
end
