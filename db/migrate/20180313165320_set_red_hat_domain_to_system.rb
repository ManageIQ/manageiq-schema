class SetRedHatDomainToSystem < ActiveRecord::Migration[5.0]
  class MiqAeNamespace < ActiveRecord::Base; end

  def up
    say_with_time('Set source to system for RedHat domain') do
      MiqAeNamespace.where(:parent_id => nil, :name => 'RedHat').update_all(:source => "system")
    end
  end
end
