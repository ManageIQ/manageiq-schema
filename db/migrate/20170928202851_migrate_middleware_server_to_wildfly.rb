class MigrateMiddlewareServerToWildfly < ActiveRecord::Migration[5.0]
  class MiddlewareServer < ApplicationRecord
  end

  def up
    say_with_time('Migrating middleware_server to middleware_server_wildfly') do
      MiddlewareServer
        .where("type = ? AND product ~* ?", 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer', 'wildfly|eap')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly')
    end
  end

  def down
    say_with_time('Migrating middleware_server_wildfly to middleware_server') do
      MiddlewareServer
        .where(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer')
    end
  end

end
