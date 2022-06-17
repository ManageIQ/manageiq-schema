class MoveBecomeMethodFromOptions < ActiveRecord::Migration[6.0]
  ALLOWED_VALUES = %w[
    sudo
    su
    pbrum
    pfexec
    doas
    dzdo
    pmrun
    runas
    enable
    ksu
    sesu
    machinectl
  ].freeze

  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    serialize :options
  end

  def up
    say_with_time("Move Authentication become_method out of options text field") do
      Authentication.in_my_region.where("options LIKE '%become_method%'").find_each do |authentication|
        next unless authentication.options&.key?(:become_method)

        # Delete the old value out of options
        become_method = authentication.options.delete(:become_method)

        # Only set the new column if the existing value is valid
        authentication.become_method = become_method if ALLOWED_VALUES.include?(become_method)

        authentication.save!
      end
    end
  end

  def down
    say_with_time("Move Authentication become_method back to options text field") do
      Authentication.in_my_region.where(:become_method => ALLOWED_VALUES).find_each do |authentication|
        authentication.options = {} if authentication.options.nil?
        authentication.options[:become_method] = authentication.become_method
        authentication.save!
      end
    end
  end
end
