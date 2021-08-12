class RemoveDeploymentFromAuthentications < ActiveRecord::Migration[6.0]
  def up
    change_table "authentications" do |t|
      t.remove :challenge
      t.remove :login
      t.remove :htpassd_users
      t.remove :ldap_id
      t.remove :ldap_email
      t.remove :ldap_name
      t.remove :ldap_preferred_user_name
      t.remove :ldap_bind_dn
      t.remove :ldap_insecure
      t.remove :ldap_url
      t.remove :request_header_challenge_url
      t.remove :request_header_login_url
      t.remove :request_header_headers
      t.remove :request_header_preferred_username_headers
      t.remove :request_header_name_headers
      t.remove :request_header_email_headers
      t.remove :open_id_sub_claim
      t.remove :open_id_user_info
      t.remove :open_id_authorization_endpoint
      t.remove :open_id_token_endpoint
      t.remove :open_id_extra_scopes
      t.remove :open_id_extra_authorize_parameters
      t.remove :certificate_authority
      t.remove :google_hosted_domain
      t.remove :github_organizations
      t.remove :rhsm_sku
      t.remove :rhsm_pool_id
      t.remove :rhsm_server
    end
  end

  def down
    change_table "authentications" do |t|
      t.boolean :challenge
      t.boolean :login
      t.text :htpassd_users, :array => true, :default => []
      t.text :ldap_id, :array => true, :default => []
      t.text :ldap_email, :array => true, :default => []
      t.text :ldap_name, :array => true, :default => []
      t.text :ldap_preferred_user_name, :array => true, :default => []
      t.string :ldap_bind_dn
      t.boolean :ldap_insecure
      t.string :ldap_url
      t.string :request_header_challenge_url
      t.string :request_header_login_url
      t.text :request_header_headers, :array => true, :default => []
      t.text :request_header_preferred_username_headers, :array => true, :default => []
      t.text :request_header_name_headers, :array => true, :default => []
      t.text :request_header_email_headers, :array => true, :default => []
      t.string :open_id_sub_claim
      t.string :open_id_user_info
      t.string :open_id_authorization_endpoint
      t.string :open_id_token_endpoint
      t.text :open_id_extra_scopes, :array => true, :default => []
      t.text :open_id_extra_authorize_parameters
      t.text :certificate_authority
      t.string :google_hosted_domain
      t.text :github_organizations, :array => true, :default => []
      t.string :rhsm_sku
      t.string :rhsm_pool_id
      t.string :rhsm_server
    end
  end
end
