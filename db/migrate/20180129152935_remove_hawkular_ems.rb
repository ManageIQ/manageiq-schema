class RemoveHawkularEms < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Removing Hawkular MiddlewareManagers") do
      ExtManagementSystem.where(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager').delete_all
    end
  end
end
