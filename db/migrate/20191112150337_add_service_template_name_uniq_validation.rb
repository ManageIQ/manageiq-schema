class AddServiceTemplateNameUniqValidation < ActiveRecord::Migration[5.1]
  class ServiceTemplate < ActiveRecord::Base
    include ActiveRecord::IdRegions
    validates :name, :uniqueness => true
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Checking service templates for name uniqueness") do
      ServiceTemplate.in_my_region.where(:name => ServiceTemplate.in_my_region.select(:name).group(:name).having("count(*) > 1").pluck(:name)).order(:id).drop(1).each { |s| s.update!(:name => s.name + SecureRandom.uuid) }
    end
  end
end
