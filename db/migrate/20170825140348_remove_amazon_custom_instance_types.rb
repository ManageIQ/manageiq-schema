class RemoveAmazonCustomInstanceTypes < ActiveRecord::Migration[5.0]
  class SettingsChange < ActiveRecord::Base
  end

  def up
    say_with_time('Remove /ems/ems_amazon/additional_instance_types/* defined also in instance_types.rb') do
      SettingsChange.where('key LIKE ?', '/ems/ems_amazon/additional_instance_types/%/name').each do |s|
        *_rest, instance_type, _name = s.key.split('/')
        if InstanceTypes::AVAILABLE_TYPES.include?(instance_type)
          SettingsChange.where('key LIKE ?', "/ems/ems_amazon/additional_instance_types/#{instance_type}/%").delete_all
        end
      end
    end
  end
end
