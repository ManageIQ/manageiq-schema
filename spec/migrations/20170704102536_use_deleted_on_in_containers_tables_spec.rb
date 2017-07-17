require_migration

describe UseDeletedOnInContainersTables do
  let(:container_definitions_stub) { migration_stub(:ContainerDefinition) }
  let(:container_groups_stub)      { migration_stub(:ContainerGroup) }
  let(:container_images_stub)      { migration_stub(:ContainerImage) }
  let(:container_projects_stub)    { migration_stub(:ContainerProject) }
  let(:container_nodes_stub)       { migration_stub(:ContainerNode) }
  let(:containers_stub)            { migration_stub(:Container) }

  def create_before_migration_stub_data_for(model)
    model.create!(:ems_id => 10, :old_ems_id => nil)
    model.create!(:ems_id => 11, :old_ems_id => 11)
    model.create!(:ems_id => nil, :old_ems_id => 12, :deleted_on => Time.now.utc)
    model.create!(:ems_id => 15, :old_ems_id => 15, :deleted_on => Time.now.utc)
    model.create!(:ems_id => nil, :old_ems_id => 20, :deleted_on => Time.now.utc)
    model.create!(:ems_id => nil, :old_ems_id => nil, :deleted_on => Time.now.utc)
    model.create!(:ems_id => nil, :old_ems_id => 25, :deleted_on => nil)
  end

  def create_after_migration_stub_data_for(model)
    model.create!(:ems_id => 10, :old_ems_id => nil)
    model.create!(:ems_id => 11, :old_ems_id => 11)
    model.create!(:ems_id => 15, :old_ems_id => 15, :deleted_on => nil)
    model.create!(:ems_id => 12, :old_ems_id => 12, :deleted_on => Time.now.utc)
    model.create!(:ems_id => 20, :old_ems_id => 20, :deleted_on => Time.now.utc)
    model.create!(:ems_id => nil, :old_ems_id => nil, :deleted_on => Time.now.utc)
    model.create!(:ems_id => 25, :old_ems_id => 25, :deleted_on => Time.now.utc)
  end

  def assert_before_migration_data_of(model, context)
    if context == :up
      expect(model.where.not(:deleted_on => nil).count).to eq 4
      expect(model.where(:deleted_on => nil).count).to eq 3
      expect(model.where.not(:deleted_on => nil).collect(&:ems_id)).to(
        match_array([15, nil, nil, nil])
      )
      expect(model.where(:deleted_on => nil).collect(&:ems_id)).to(
        match_array([10, 11, nil])
      )
    else
      expect(model.where.not(:deleted_on => nil).count).to eq 4
      expect(model.where(:deleted_on => nil).count).to eq 3
      expect(model.where.not(:deleted_on => nil).collect(&:ems_id)).to(
        match_array([nil, nil, nil, nil])
      )
      expect(model.where(:deleted_on => nil).collect(&:ems_id)).to(
        match_array([10, 11, 15])
      )
    end
    expect(model.where(:ems_id => nil).count).to eq 4
    expect(model.where(:ems_id => 10).count).to eq 1
    expect(model.where(:ems_id => 11).count).to eq 1
    expect(model.where(:ems_id => 12).count).to eq 0
    expect(model.where(:ems_id => 15).count).to eq 1
    expect(model.where(:ems_id => 20).count).to eq 0
    expect(model.where(:ems_id => 25).count).to eq 0
    expect(model.where.not(:ems_id => nil).count).to eq 3
  end

  def assert_after_migration_data_of(model)
    expect(model.where.not(:deleted_on => nil).count).to eq 4
    expect(model.where.not(:deleted_on => nil).collect(&:ems_id)).to(
      match_array([12, 20, nil, 25])
    )
    expect(model.where(:deleted_on => nil).count).to eq 3
    expect(model.where(:deleted_on => nil).collect(&:ems_id)).to(
      match_array([10, 11, 15])
    )
    expect(model.where(:ems_id => nil).count).to eq 1
    expect(model.where(:ems_id => 10).count).to eq 1
    expect(model.where(:ems_id => 11).count).to eq 1
    expect(model.where(:ems_id => 12).count).to eq 1
    expect(model.where(:ems_id => 15).count).to eq 1
    expect(model.where(:ems_id => 20).count).to eq 1
    expect(model.where(:ems_id => 25).count).to eq 1
    expect(model.where.not(:ems_id => nil).count).to eq 6
  end

  def assert_up_migration_for(model)
    create_before_migration_stub_data_for(model)

    assert_before_migration_data_of(model, :up)
    migrate
    assert_after_migration_data_of(model)
  end

  def assert_down_migration_for(model)
    create_after_migration_stub_data_for(model)

    assert_after_migration_data_of(model)
    migrate
    assert_before_migration_data_of(model, :down)
  end

  ALL_STUBS = [
    :container_definitions_stub,
    :container_groups_stub,
    :container_images_stub,
    :container_projects_stub,
    :container_nodes_stub,
    :containers_stub
  ].freeze

  migration_context :up do
    ALL_STUBS.each do |stub|
      context "with #{stub}" do
        it "change ':deleted_on not nil' :ems_id to :old_ems_id" do
          assert_up_migration_for(public_send(stub))
        end
      end
    end
  end

  migration_context :down do
    ALL_STUBS.each do |stub|
      context "with #{stub}" do
        it "change ':deleted_on not nil' :ems_id to nil" do
          assert_down_migration_for(public_send(stub))
        end
      end
    end
  end
end
