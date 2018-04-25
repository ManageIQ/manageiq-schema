class DropWebmks < ActiveRecord::Migration[5.0]
  class MiqServer < ActiveRecord::Base; end
  class SettingsChange < ActiveRecord::Base; end

  def up
    say_with_time "Remove all VMware MKS console-related records from settings" do
      SettingsChange.where(:key => '/server/remote_console_type', :value => 'MKS').delete_all
    end
  end
end
