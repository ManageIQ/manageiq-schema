class UpgradeDropboxToSupportTool < ActiveRecord::Migration[5.1]
  class FileDepot < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def change
    # update_all is used here to avoid instantiating a possibly undefined class
    FileDepot.where(:type => "FileDepotFtpAnonymousRedhatDropbox").update_all(
      :type => "FileDepotRedhatSupport",
      :name => "Red Hat Support",
      :uri  => "support://redhat.com"
    )
  end
end
