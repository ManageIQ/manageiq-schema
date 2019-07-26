require_migration

describe RemoveLocalDefaultEmbeddedAnsibleRepos do
  let(:configuration_script_source_stub) { migration_stub(:ConfigurationScriptSource) }
  let(:git_repository_stub)              { migration_stub(:GitRepository) }
  let(:embedded_ansible_source_type)     { "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScriptSource" }
  let(:ansible_tower_source_type)        { "ManageIQ::Providers::AnsibleTower::AutomationManager::ConfigurationScriptSource" }

  migration_context :up do
    it "removes configuration script sources at /var/lib/awx_consolidated_source" do
      source = configuration_script_source_stub.create!(
        :type    => embedded_ansible_source_type,
        :scm_url => "file:///var/lib/awx_consolidated_source"
      )

      configuration_script_source_stub.create!(
        :type    => embedded_ansible_source_type,
        :scm_url => "https://example.com/git_repos/playbooks"
      )

      migrate

      expect(configuration_script_source_stub.find_by(:id => source.id)).to be_nil
      expect(configuration_script_source_stub.count).to eq(1)
      expect(configuration_script_source_stub.first.scm_url).to eq("https://example.com/git_repos/playbooks")
    end

    it "removes configuration script sources at /content/ansible_consolidated" do
      source = configuration_script_source_stub.create!(
        :type    => embedded_ansible_source_type,
        :scm_url => "file:///home/ncarboni/Source/manageiq/content/ansible_consolidated"
      )

      configuration_script_source_stub.create!(
        :type    => embedded_ansible_source_type,
        :scm_url => "https://example.com/git_repos/playbooks"
      )

      migrate

      expect(configuration_script_source_stub.find_by(:id => source.id)).to be_nil
      expect(configuration_script_source_stub.count).to eq(1)
      expect(configuration_script_source_stub.first.scm_url).to eq("https://example.com/git_repos/playbooks")
    end

    it "removes related git repositories" do
      git_repository_stub.create!(:url => "https://example.com/git_repos/playbooks")

      repo = git_repository_stub.create!(:url => "file:///home/ncarboni/Source/manageiq/content/ansible_consolidated")
      source = configuration_script_source_stub.create!(
        :type              => embedded_ansible_source_type,
        :scm_url           => "file:///home/ncarboni/Source/manageiq/content/ansible_consolidated",
        :git_repository_id => repo.id
      )

      migrate

      expect(configuration_script_source_stub.find_by(:id => source.id)).to be_nil
      expect(git_repository_stub.find_by(:id => repo.id)).to be_nil
      expect(git_repository_stub.count).to eq(1)
      expect(git_repository_stub.first.url).to eq("https://example.com/git_repos/playbooks")
    end

    it "doesn't remove sources for ansible tower" do
      tower_source = configuration_script_source_stub.create!(
        :type    => ansible_tower_source_type,
        :scm_url => "file:///home/ncarboni/Source/manageiq/content/ansible_consolidated"
      )

      migrate

      expect(configuration_script_source_stub.find_by(:id => tower_source.id)).to_not be_nil
    end
  end
end
