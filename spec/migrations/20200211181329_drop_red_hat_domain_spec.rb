require_migration

describe DropRedHatDomain do
  let(:miq_ae_namespace_stub) { migration_stub(:MiqAeNamespace) }
  let(:miq_ae_class_stub) { migration_stub(:MiqAeClass) }
  let(:miq_ae_method_stub) { migration_stub(:MiqAeMethod) }
  let(:miq_ae_field_stub) { migration_stub(:MiqAeField) }
  let(:miq_ae_instance_stub) { migration_stub(:MiqAeInstance) }
  let(:miq_ae_value_stub) { migration_stub(:MiqAeValue) }

  migration_context :up do
    it "drops domain, classes, methods, fields from RH domain" do
      namespace = miq_ae_namespace_stub.create!(:name => 'RedHat', :parent_id => nil)
      namespace2 = miq_ae_namespace_stub.create!(:name => 'RedHat2', :parent_id => namespace.id)
      namespace3 = miq_ae_namespace_stub.create!(:name => 'RedHat3', :parent_id => namespace2.id)
      ae_class = miq_ae_class_stub.create!(:namespace_id => namespace2.id)
      ae_class2 = miq_ae_class_stub.create!(:namespace_id => namespace3.id)
      ae_class3 = miq_ae_class_stub.create!(:namespace_id => namespace.id)
      miq_ae_method_stub.create!(:class_id => ae_class.id)
      miq_ae_field_stub.create!(:class_id => ae_class.id)
      miq_ae_field_stub.create!(:class_id => ae_class2.id)
      miq_ae_field_stub.create!(:class_id => ae_class3.id)
      ae_instance = miq_ae_instance_stub.create!(:class_id => ae_class.id)
      ae_instance2 = miq_ae_instance_stub.create!(:class_id => ae_class2.id)
      ae_instance3 = miq_ae_instance_stub.create!(:class_id => ae_class3.id)
      miq_ae_value_stub.create!(:instance_id => ae_instance.id)
      miq_ae_value_stub.create!(:instance_id => ae_instance2.id)
      miq_ae_value_stub.create!(:instance_id => ae_instance3.id)

      migrate

      expect(miq_ae_namespace_stub.find_by(:name => 'RedHat')).to eq(nil)
      expect(miq_ae_class_stub.count).to eq(0)
      expect(miq_ae_field_stub.count).to eq(0)
      expect(miq_ae_method_stub.count).to eq(0)
      expect(miq_ae_instance_stub.count).to eq(0)
      expect(miq_ae_value_stub.count).to eq(0)
    end

    it "doesn't drop domain, classes, methods, fields from other domain" do
      namespace = miq_ae_namespace_stub.create!(:name => 'NotRedHat', :parent_id => nil)
      namespace2 = miq_ae_namespace_stub.create!(:name => 'RedHat2', :parent_id => namespace.id)
      ae_class = miq_ae_class_stub.create!(:namespace_id => namespace2.id)
      miq_ae_method_stub.create!(:class_id => ae_class.id)
      miq_ae_field_stub.create!(:class_id => ae_class.id)
      ae_instance = miq_ae_instance_stub.create!(:class_id => ae_class.id)
      miq_ae_value_stub.create!(:instance_id => ae_instance.id)

      migrate

      expect(miq_ae_namespace_stub.find_by(:name => 'RedHat')).to eq(nil)
      expect(miq_ae_namespace_stub.count).to eq(2)
      expect(miq_ae_class_stub.count).to eq(1)
      expect(miq_ae_field_stub.count).to eq(1)
      expect(miq_ae_method_stub.count).to eq(1)
      expect(miq_ae_instance_stub.count).to eq(1)
      expect(miq_ae_value_stub.count).to eq(1)
    end
  end
end
