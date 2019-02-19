class AddCommentsToAuthenticationsTable < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :authentications, "Authentication information for various resources"

    change_column_comment :authentications, :id, "[builtin] The internal record ID. This is the primary key."
    change_column_comment :authentications, :name, "Symbolic name for the authentication"
    change_column_comment :authentications, :authtype, "The authentication type or role, e.g. ssh_keypair, default, amqp, etc."
    change_column_comment :authentications, :userid, "The userid used in a userid + password authentication approach."
    change_column_comment :authentications, :password, "The password for the given userid, if any. Encrypted."
    change_column_comment :authentications, :resource_id, "The ID of the associated resource."
    change_column_comment :authentications, :resource_type, "The STI type of the associated resource."
    change_column_comment :authentications, :created_on, "[builtin] The timestamp the record was created."
    change_column_comment :authentications, :updated_on, "[builtin] The timestamp the record was last updated."
    change_column_comment :authentications, :last_valid_on, "The timestamp this authentication was last used successfully."
    change_column_comment :authentications, :last_invalid_on "The timestamp this authentication last failed."
    change_column_comment :authentications, :credentials_changed_on, "The timestamp that credentials were last changed."
    change_column_comment :authentications, :status, "The current status of the authentication, e.g. valid, invalid, incomplete, etc."
    change_column_comment :authentications, :status_details, "Detailed information regarding the current status."
    change_column_comment :authentications, :type, "The STI type of the authentication, e.g. AuthKeyPair, AuthToken, AuthUseridPassword, etc."
    change_column_comment :authentications, :auth_key, "The private ssh key associated with the resource. Encrypted."
    change_column_comment :authentications, :fingerprint, "The RSA key fingerprint for the SSH public key."
    change_column_comment :authentications, :service_account
    change_column_comment :authentications, :challenge
    change_column_comment :authentications, :login
    change_column_comment :authentications, :public_key, "An SSH public key."
    change_column_comment :authentications, :htpassd_users
    change_column_comment :authentications, :ldap_id
    change_column_comment :authentications, :ldap_email
    change_column_comment :authentications, :ldap_name
    change_column_comment :authentications, :ldap_preferred_user_name
    change_column_comment :authentications, :ldap_bind_dn
    change_column_comment :authentications, :ldap_insecure
    change_column_comment :authentications, :ldap_url
    change_column_comment :authentications, :request_header_challenge_url
    change_column_comment :authentications, :request_header_login_url
    change_column_comment :authentications, :request_header_headers
    change_column_comment :authentications, :request_header_preferred_username_headers
    change_column_comment :authentications, :request_header_name_headers
    change_column_comment :authentications, :request_header_email_headers
    change_column_comment :authentications, :open_id_sub_claim
    change_column_comment :authentications, :open_id_user_info
    change_column_comment :authentications, :open_id_authorization_endpoint
    change_column_comment :authentications, :open_id_token_endpoint
    change_column_comment :authentications, :open_id_extra_scopes
    change_column_comment :authentications, :open_id_extra_authorize_parameters
    change_column_comment :authentications, :certificate_authority
    change_column_comment :authentications, :google_hosted_domain
    change_column_comment :authentications, :github_organizations
    change_column_comment :authentications, :rhsm_sku
    change_column_comment :authentications, :rhsm_pool_id
    change_column_comment :authentications, :rhsm_server
    change_column_comment :authentications, :manager_ref
    change_column_comment :authentications, :options
    change_column_comment :authentications, :evm_owner_id, "The ID of the associated EVM owner, if any."
    change_column_comment :authentications, :miq_group_id, "The ID of the associated MIQ group, if any."
    change_column_comment :authentications, :tenant_id, "The ID of the associated tenant, if any."
  end
end
