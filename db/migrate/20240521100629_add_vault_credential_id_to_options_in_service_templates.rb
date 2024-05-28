class AddVaultCredentialIdToOptionsInServiceTemplates < ActiveRecord::Migration[6.1]
  class ServiceTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    serialize :options
  end

  def up
    say_with_time("Updating vault_credential_id values") do
      ServiceTemplate.all.each do |record|
        update_vault_credential_id(record, :provision)
        update_vault_credential_id(record, :retirement)
      end
    end
  end

  def down
    say_with_time("Removing vault_credential_id values") do
      ServiceTemplate.all.each do |record|
        clear_vault_credential_id(record, :provision)
        clear_vault_credential_id(record, :retirement)
      end
    end
  end

  private

  def update_vault_credential_id(record, action)
    config_info = record.options&.dig(:config_info, action)
    if config_info && (vault_credentials = config_info[:vault_credentials])
      config_info[:vault_credential_id] = vault_credentials
      config_info.delete(:vault_credentials)
      record.update!(:options => record.options)
    end
  end

  def clear_vault_credential_id(record, action)
    config_info = record.options&.dig(:config_info, action)
    if config_info && (vault_credential_id = config_info[:vault_credential_id])
      config_info[:vault_credentials] = vault_credential_id
      config_info.delete(:vault_credential_id)
      record.update!(:options => record.options)
    end
  end
end
