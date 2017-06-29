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
      :ems_ref    => "123",
      :ems_id     => 1,
      :old_ems_id => 1,
      :deleted_on => Time.now.beginning_of_hour.utc
    }
  end

  migration_context :up do
    it "merges container_defintion and container" do
      container_def = container_definition_stub.create!(definition_hash)
      container = container_stub.create!(container_hash.merge(:container_definition => container_def))
      container_env_var_stub.create!(:name                    => "REGISTRY_HTTP_ADDR",
                                     :value                   => ":5000",
                                     :container_definition_id => container_def.id)
      container_port_config_stub.create!(:ems_ref                 => "2da0c9e4",
                                         :port                    => 5000,
                                         :protocol                => "TCP",
                                         :container_definition_id => container_def.id)
      security_context_stub.create!(:se_linux_level => "s0:c1,c0",
                                    :resource_id    => container_def.id,
                                    :resource_type  => 'ContainerDefinition')

      container_def2 = container_definition_stub.create!(definition_hash.merge(:image => "my_image2"))
      container2 = container_stub.create!(container_hash.merge(:container_definition => container_def2, :name => "mycontainer2"))
      container_def2.container_env_vars << container_env_var_stub.create!(:name  => "REGISTRY_HTTP_ADDR",
                                                                          :value => ":5000")
      container_def2.container_port_configs << container_port_config_stub.create!(:ems_ref  => "2da0c9e4",
                                                                                  :port     => 5000,
                                                                                  :protocol => "TCP")
      security_context_stub.create!(:se_linux_level => "s0:c1,c0",
                                    :resource_id    => container_def2.id,
                                    :resource_type  => 'ContainerDefinition')

      migrate

      expect(container_stub.first).to have_attributes(definition_hash.merge(container_hash))

      expect(container_port_config_stub.first).to have_attributes(:container_id => container.id)
      expect(container_env_var_stub.first).to have_attributes(:container_id => container.id)
      expect(security_context_stub.first).to have_attributes(:resource_type => "Container",
                                                             :resource_id   => container.id)

      expect(container_port_config_stub.second).to have_attributes(:container_id => container2.id)
      expect(container_env_var_stub.second).to have_attributes(:container_id => container2.id)
      expect(security_context_stub.second).to have_attributes(:resource_type => "Container",
                                                              :resource_id   => container2.id)
    end
  end

  migration_context :down do
    it "splits container_definition columns from container" do
      container = container_stub.create!(definition_hash.merge(container_hash))
      container_env_var_stub.create!(:name         => "REGISTRY_HTTP_ADDR",
                                     :value        => ":5000", :field_path => nil,
                                     :container_id => container.id)
      container_port_config_stub.create!(:ems_ref      => "2da0c9e4",
                                         :port         => 5000,
                                         :protocol     => "TCP",
                                         :container_id => container.id)
      security_context_stub.create!(:resource_type  => "Container",
                                    :resource_id    => container.id,
                                    :se_linux_level => "s0:c1,c0")

      migrate

      container_def = container_definition_stub.first
      expect(container_def).to have_attributes(definition_hash)
      expect(container_env_var_stub.first).to have_attributes(:container_definition_id => container_def.id)
      expect(container_port_config_stub.first).to have_attributes(:container_definition_id => container_def.id)
      expect(security_context_stub.first).to have_attributes(:resource_type => "ContainerDefinition",
                                                             :resource_id   => container_def.id)
    end
  end
end
