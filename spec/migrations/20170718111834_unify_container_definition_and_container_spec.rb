require_migration

describe UnifyContainerDefinitionAndContainer do
  let(:container_stub) { migration_stub(:Container) }
  let(:container_definition_stub) { migration_stub(:ContainerDefinition) }

  let(:security_context_stub) { migration_stub(:SecurityContext) }
  let(:container_env_var_stub) { migration_stub(:ContainerEnvVar) }
  let(:container_port_config_stub) { migration_stub(:ContainerPortConfig) }

  let(:definition_hash) do
    {
      :image              => "my_image",
      :image_pull_policy  => "image_pull_policy",
      :memory             => "memory",
      :cpu_cores          => 1.1,
      :container_group_id => 1,
      :privileged         => true,
      :run_as_user        => 2,
      :run_as_non_root    => true,
      :capabilities_add   => "capabilities_add",
      :capabilities_drop  => "capabilities_drop",
      :command            => "command"
    }
  end

  let(:container_hash) do
    {
      :name       => "mycontainer",
      :ems_ref    => "2da0c9e4-e6f9-11e6-a348-001a4a162683_registry_openshift/origin-docker-registry:v1.3.3",
      :ems_id     => 1,
      :old_ems_id => nil,
      :deleted_on => Time.now.beginning_of_hour.utc
    }
  end

  let(:queue_stub) { migration_stub(:MiqQueue) }

  migration_context :up do
    it "merges container_defintion and container" do
      container_def = container_definition_stub.create!(definition_hash)
      container = container_stub.create!(container_hash.merge(:container_definition => container_def))
      env_var = container_env_var_stub.create!(:name                    => "REGISTRY_HTTP_ADDR",
                                               :value                   => ":5000",
                                               :container_definition_id => container_def.id)
      port_config = container_port_config_stub.create!(:ems_ref                 => "2da0c9e4",
                                                       :port                    => 5000,
                                                       :protocol                => "TCP",
                                                       :container_definition_id => container_def.id)
      security_context = security_context_stub.create!(:se_linux_level => "s0:c1,c0",
                                                       :resource_id    => container_def.id,
                                                       :resource_type  => 'ContainerDefinition')

      container_def2 = container_definition_stub.create!(definition_hash.merge(:image => "my_image2"))
      container2 = container_stub.create!(container_hash.merge(:container_definition => container_def2,
                                                               :name                 => "mycontainer2"))
      env_var2 = container_env_var_stub.create!(:name                    => "REGISTRY_HTTP_ADDR",
                                                :value                   => ":6000",
                                                :container_definition_id => container_def2.id)
      port_config2 = container_port_config_stub.create!(:ems_ref                 => "2da0c9e4",
                                                        :port                    => 6000,
                                                        :protocol                => "TCP",
                                                        :container_definition_id => container_def2.id)
      security_context2 = security_context_stub.create!(:se_linux_level => "s1:c1,c0",
                                                        :resource_id    => container_def2.id,
                                                        :resource_type  => 'ContainerDefinition')

      migrate

      expect(container.reload).to have_attributes(definition_hash.merge(container_hash))

      expect(port_config.reload).to have_attributes(:container_id => container.id)
      expect(env_var.reload).to have_attributes(:container_id => container.id)
      expect(security_context.reload).to have_attributes(:resource_type => "Container",
                                                         :resource_id   => container.id)

      expect(port_config2.reload).to have_attributes(:container_id => container2.id)
      expect(env_var2.reload).to have_attributes(:container_id => container2.id)
      expect(security_context2.reload).to have_attributes(:resource_type => "Container",
                                                          :resource_id   => container2.id)
    end

    it "does not fail when container_definition has no container" do
      container_def = container_definition_stub.create!(definition_hash)
      container = container_stub.create!(container_hash.merge(:container_definition => container_def))
      env_var = container_env_var_stub.create!(:name                    => "REGISTRY_HTTP_ADDR",
                                               :value                   => ":5000",
                                               :container_definition_id => container_def.id)
      port_config = container_port_config_stub.create!(:ems_ref                 => "2da0c9e4",
                                                       :port                    => 5000,
                                                       :protocol                => "TCP",
                                                       :container_definition_id => container_def.id)
      security_context = security_context_stub.create!(:se_linux_level => "s0:c1,c0",
                                                       :resource_id    => container_def.id,
                                                       :resource_type  => 'ContainerDefinition')

      container_def2 = container_definition_stub.create!(definition_hash.merge(:image => "my_image2"))

      env_var2 = container_env_var_stub.create!(:name                    => "REGISTRY_HTTP_ADDR",
                                                :value                   => ":6000",
                                                :container_definition_id => container_def2.id)
      port_config2 = container_port_config_stub.create!(:ems_ref                 => "2da0c9e4",
                                                        :port                    => 6000,
                                                        :protocol                => "TCP",
                                                        :container_definition_id => container_def2.id)
      security_context2 = security_context_stub.create!(:se_linux_level => "s1:c1,c0",
                                                        :resource_id    => container_def2.id,
                                                        :resource_type  => 'ContainerDefinition')

      migrate

      expect(container.reload).to have_attributes(definition_hash.merge(container_hash))
      expect(port_config.reload).to have_attributes(:container_id => container.id)
      expect(env_var.reload).to have_attributes(:container_id => container.id)
      expect(security_context.reload).to have_attributes(:resource_type => "Container",
                                                         :resource_id   => container.id)
    end

    it "deletes purge jobs from the queue" do
      queue_stub.create(:class_name => "ContainerDefinition", :method_name => "purge_timer")

      migrate

      expect(queue_stub.where(:method_name => "purge_timer", :class_name => 'ContainerDefinition').count).to eq(0)
    end
  end

  migration_context :down do
    it "splits container_definition columns from container" do
      container = container_stub.create!(definition_hash.merge(container_hash))
      env_var = container_env_var_stub.create!(:name         => "REGISTRY_HTTP_ADDR",
                                               :value        => ":5000", :field_path => nil,
                                               :container_id => container.id)
      port_config = container_port_config_stub.create!(:ems_ref      => "2da0c9e4",
                                                       :port         => 5000,
                                                       :protocol     => "TCP",
                                                       :container_id => container.id)
      security_context = security_context_stub.create!(:resource_type  => "Container",
                                                       :resource_id    => container.id,
                                                       :se_linux_level => "s0:c0,c0")

      container2 = container_stub.create!(definition_hash.merge(container_hash).merge(:name => "mycontainer2"))
      env_var2 = container_env_var_stub.create!(:name         => "REGISTRY_HTTP_ADDR",
                                                :value        => ":6000",
                                                :container_id => container2.id)
      port_config2 = container_port_config_stub.create!(:ems_ref      => "c9e42da0",
                                                        :port         => 6000,
                                                        :protocol     => "TCP",
                                                        :container_id => container2.id)
      security_context2 = security_context_stub.create!(:se_linux_level => "s1:c1,c0",
                                                        :resource_id    => container2.id,
                                                        :resource_type  => 'Container')
      migrate

      container.reload
      container_def = container_definition_stub.find(container.container_definition_id)
      expect(container_def).to have_attributes(definition_hash.merge(:ems_ref    => container.ems_ref,
                                                                     :ems_id     => container.ems_id,
                                                                     :old_ems_id => container.old_ems_id,
                                                                     :deleted_on => container.deleted_on))
      expect(env_var.reload).to have_attributes(:value => ":5000")
      expect(port_config.reload).to have_attributes(:port => 5000)
      expect(security_context.reload).to have_attributes(:se_linux_level => "s0:c0,c0")

      container2.reload
      container_def2 = container_definition_stub.find(container2.container_definition_id)
      expect(container_def2.name).to eq("mycontainer2")
      expect(env_var2.reload).to have_attributes(:value => ":6000")
      expect(port_config2.reload).to have_attributes(:port => 6000)
      expect(security_context2.reload).to have_attributes(:se_linux_level => "s1:c1,c0")
    end
  end
end
