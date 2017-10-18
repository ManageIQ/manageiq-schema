class FixHawkularEndpointsWithPortNil < ActiveRecord::Migration[5.0]
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Endpoint < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    container_hawkular_endpoints.where(:port => nil).update_all(:port => 443)
  end

  def container_hawkular_endpoints
    ems_container_ids = ExtManagementSystem.where(
      :type => %w(ManageIQ::Providers::Openshift::ContainerManager ManageIQ::Providers::Kubernetes::ContainerManager)
    ).pluck(:id)

    Endpoint.where(
      :resource_type => 'ExtManagementSystem',
      :resource_id   => ems_container_ids,
      :role          => 'hawkular'
    )
  end
end
