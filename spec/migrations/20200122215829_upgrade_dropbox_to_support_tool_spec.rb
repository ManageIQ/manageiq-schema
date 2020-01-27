require_migration

describe UpgradeDropboxToSupportTool do
  let(:file_depot) { migration_stub(:FileDepot) }

  migration_context :up do
    it "upgrades only existing dropbox depots to support tool" do
      dropbox_depot = file_depot.create!(
        :type => "FileDepotFtpAnonymousRedhatDropbox",
        :name => "Red Hat Dropbox"
      )

      ftp_depot = file_depot.create!(:type => "FileDepotFtp")

      migrate

      dropbox_depot.reload
      expect(dropbox_depot.type).to eq "FileDepotRedhatSupport"
      expect(dropbox_depot.name).to eq "Red Hat Support"

      ftp_depot.reload
      expect(ftp_depot.type).to eq "FileDepotFtp"
    end
  end
end
