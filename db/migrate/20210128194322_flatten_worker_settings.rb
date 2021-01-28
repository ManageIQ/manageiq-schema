class FlattenWorkerSettings < ActiveRecord::Migration[6.0]
  class SettingsChange < ActiveRecord::Base
    def self.replace_starts_with(starts_with, replace, except = [])
      query = where("key LIKE ?", "#{starts_with}%")
      except.each { |e| query = query.where.not("key LIKE ?", e) }
      query.update_all("key = REGEXP_REPLACE(key, '^#{starts_with}', '#{replace}')")
    end
  end

  WORKER_BASE_WORKERS = %w[
    agent_coordinator_worker
    cockpit_ws_worker
    event_catcher
    queue_worker_base
    remote_console_worker
    schedule_worker
    ui_worker
    web_service_worker
  ].freeze

  QUEUE_WORKER_BASE_WORKERS = %w[
    ems_metrics_collector_worker
    ems_metrics_processor_worker
    ems_operations_worker
    ems_refresh_worker
    event_handler
    generic_worker
    priority_worker
    reporting_worker
    smart_proxy_worker
  ].freeze

  PROVIDER_WORKERS = %w[
    ems_metrics_collector_worker
    ems_operations_worker
    ems_refresh_worker
    event_catcher
  ].freeze

  PROVIDER_WORKER_EXCEPTIONS = %w[
    event_catcher_openstack_service
    ems_metrics_openstack_default_service
    ems_metrics_gnocchi_granularity
  ].freeze

  def up
    say_with_time("Flattening nested worker settings") do
      promote("/workers/worker_base")

      promote("/workers/queue_worker_base")

      PROVIDER_WORKERS.each do |w|
        promote("/workers/#{w}", PROVIDER_WORKER_EXCEPTIONS)
      end
    end
  end

  private def promote(key, except = [])
    promote_non_defaults(key, except)
    promote_defaults(key)
  end

  # Moves all child keys of the given key, except the defaults and those specified, into the parent
  private def promote_non_defaults(key, except)
    except = except.map { |e| "#{key}/#{e}" } + ["#{key}/defaults/%"]
    parent = key.split("/")[0..-2].join("/")
    SettingsChange.replace_starts_with("#{key}/", "#{parent}/", except)
  end

  # Moves all keys under defaults into the parent
  private def promote_defaults(key)
    SettingsChange.replace_starts_with("#{key}/defaults/", "#{key}/")
  end

  def down
    say_with_time("Unflattening nested worker settings") do
      PROVIDER_WORKERS.each do |w|
        demote("/workers/#{w}", ["#{w}_"], PROVIDER_WORKER_EXCEPTIONS)
      end

      demote("/workers/queue_worker_base", QUEUE_WORKER_BASE_WORKERS.map { |w| "#{w}/" })

      demote("/workers/worker_base", WORKER_BASE_WORKERS.map { |w| "#{w}/" })
    end
  end

  def demote(key, child_prefixes, except = [])
    demote_defaults(key, except.map { |e| "#{key}/#{e}" })
    demote_non_defaults(key, child_prefixes)
  end

  # Moves all child keys of the given key under defaults
  private def demote_defaults(key, except)
    SettingsChange.replace_starts_with("#{key}/", "#{key}/defaults/", except)
  end

  # Moves all top-level keys starting with the given child prefixes under the given key
  private def demote_non_defaults(key, child_prefixes)
    child_prefixes.each do |child_prefix|
      SettingsChange.replace_starts_with("/workers/#{child_prefix}", "#{key}/#{child_prefix}")
    end
  end
end
