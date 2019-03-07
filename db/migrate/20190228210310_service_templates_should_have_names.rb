class ServiceTemplatesShouldHaveNames < ActiveRecord::Migration[5.0]
  class ServiceTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Checking service templates for names") do
      ServiceTemplate.in_my_region.where(:name => [nil, ""]).each { |t| t.update_attributes!(:name => "ServiceTemplate" + SecureRandom.uuid) }
    end
  end
end
