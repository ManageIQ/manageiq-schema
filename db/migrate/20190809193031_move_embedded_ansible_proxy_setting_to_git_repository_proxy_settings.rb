class MoveEmbeddedAnsibleProxySettingToGitRepositoryProxySettings < ActiveRecord::Migration[5.1]
  class SettingsChange < ActiveRecord::Base
    serialize :value
  end

  def up
    say_with_time("Moving embedded ansible proxy settings to git repository proxy settings") do
      SettingsChange.where("key LIKE ?", "/http_proxy/embedded_ansible/%").each do |s|
        s.key = s.key.sub("/http_proxy/embedded_ansible", "/git_repository_proxy")
        s.save!
      end
    end
  end

  def down
    say_with_time("Moving git repository proxy settings to embedded ansible proxy settings") do
      SettingsChange.where("key LIKE ?", "/git_repository_proxy/%").each do |s|
        s.key = s.key.sub("/git_repository_proxy", "/http_proxy/embedded_ansible")
        s.save!
      end
    end
  end
end
