require_migration

describe AddVaultCredentialIdToOptionsInServiceTemplates do
  let(:service_template_stub) { migration_stub(:ServiceTemplate) }

  migration_context :up do
    it "converts vault_credentials to vault_credential_id in provision and retirement options" do
      service_template = service_template_stub.create!(:options => service_template_up_options)
      migrate
      expect(service_template.reload.options[:config_info][:provision]).to_not have_key(:vault_credentials)
      expect(service_template.reload.options[:config_info][:provision][:vault_credential_id]).to eq('provision_credentials')
      expect(service_template.reload.options[:config_info][:retirement]).to_not have_key(:vault_credentials)
      expect(service_template.reload.options[:config_info][:retirement][:vault_credential_id]).to eq('retirement_credentials')
    end
  end

  migration_context :down do
    it "converts vault_credential_id to vault_credentials in provision and retirement options" do
      service_template = service_template_stub.create!(:options => service_template_down_options)
      migrate
      expect(service_template.reload.options[:config_info][:provision]).to_not have_key(:vault_credential_id)
      expect(service_template.reload.options[:config_info][:provision][:vault_credentials]).to eq("provision_credentials")
      expect(service_template.reload.options[:config_info][:retirement]).to_not have_key(:vault_credential_id)
      expect(service_template.reload.options[:config_info][:retirement][:vault_credentials]).to eq("retirement_credentials")
    end
  end

  private

  def service_template_up_options
    {
      :config_info => {
        :provision  => {:vault_credentials => 'provision_credentials'},
        :retirement => {:vault_credentials => 'retirement_credentials'}
      }
    }
  end

  def service_template_down_options
    {
      :config_info => {
        :provision  => {:vault_credentials => 'provision_credentials'},
        :retirement => {:vault_credentials => 'retirement_credentials'}
      }
    }
  end
end
