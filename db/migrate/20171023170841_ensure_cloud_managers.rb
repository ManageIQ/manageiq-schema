class EnsureCloudManagers < ActiveRecord::Migration[5.0]
  def change
    ManageIQ::Providers::CloudManager.all.each { |x| x.send(:ensure_managers); x.save!; }
  end
end
