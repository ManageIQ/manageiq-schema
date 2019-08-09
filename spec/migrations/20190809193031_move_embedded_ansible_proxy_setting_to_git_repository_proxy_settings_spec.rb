require_migration

describe MoveEmbeddedAnsibleProxySettingToGitRepositoryProxySettings do
  let(:settings_stub) { migration_stub(:SettingsChange) }

  migration_context :up do
    it "moves the embedded ansible settings to git repository settings" do
      settings_stub.create!(:key => "/http_proxy/embedded_ansible/host", :value => "example.com")
      settings_stub.create!(:key => "/http_proxy/embedded_ansible/password", :value => "password")
      settings_stub.create!(:key => "/http_proxy/embedded_ansible/port", :value => 80)
      settings_stub.create!(:key => "/http_proxy/embedded_ansible/user", :value => "root")
      settings_stub.create!(:key => "/http_proxy/embedded_ansible/scheme", :value => "http")

      migrate

      expect(settings_stub.where(:key => "/git_repository_proxy/host").first.value).to eq("example.com")
      expect(settings_stub.where(:key => "/git_repository_proxy/password").first.value).to eq("password")
      expect(settings_stub.where(:key => "/git_repository_proxy/port").first.value).to eq(80)
      expect(settings_stub.where(:key => "/git_repository_proxy/user").first.value).to eq("root")
      expect(settings_stub.where(:key => "/git_repository_proxy/scheme").first.value).to eq("http")
    end
  end

  migration_context :down do
    it "moves the git repository settings to embedded ansible settings" do
      settings_stub.create!(:key => "/git_repository_proxy/host", :value => "example.com")
      settings_stub.create!(:key => "/git_repository_proxy/password", :value => "password")
      settings_stub.create!(:key => "/git_repository_proxy/port", :value => 80)
      settings_stub.create!(:key => "/git_repository_proxy/user", :value => "root")
      settings_stub.create!(:key => "/git_repository_proxy/scheme", :value => "http")

      migrate

      expect(settings_stub.where(:key => "/http_proxy/embedded_ansible/host").first.value).to eq("example.com")
      expect(settings_stub.where(:key => "/http_proxy/embedded_ansible/password").first.value).to eq("password")
      expect(settings_stub.where(:key => "/http_proxy/embedded_ansible/port").first.value).to eq(80)
      expect(settings_stub.where(:key => "/http_proxy/embedded_ansible/user").first.value).to eq("root")
      expect(settings_stub.where(:key => "/http_proxy/embedded_ansible/scheme").first.value).to eq("http")
    end
  end
end
