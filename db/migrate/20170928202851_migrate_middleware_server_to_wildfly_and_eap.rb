class MigrateMiddlewareServerToWildflyAndEap < ActiveRecord::Migration[5.0]
  class MiddlewareServer < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time('Migrating middleware_server to middleware_server_wildfly') do
      MiddlewareServer
        .where("type = ? AND product ~* ?", 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer', 'wildfly')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly')
    end

    say_with_time('Migrating middleware_server to middleware_server_eap') do
      MiddlewareServer
        .where("type = ? AND product ~* ?", 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer', 'eap')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerEap')
    end
  end

  def down
    say_with_time('Migrating middleware_server_wildfly to middleware_server') do
      MiddlewareServer
        .where(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerWildfly')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer')
    end

    say_with_time('Migrating middleware_server_eap to middleware_server') do
      MiddlewareServer
        .where(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServerEap')
        .update_all(:type => 'ManageIQ::Providers::Hawkular::MiddlewareManager::MiddlewareServer')
    end
  end

end
