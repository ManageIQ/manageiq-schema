require_migration

describe AddDomainAndRelativePathToAutomate do
  let(:dom_stub) { migration_stub(:MiqAeDomain) }
  let(:ns_stub) { migration_stub(:MiqAeNamespace) }
  let(:class_stub) { migration_stub(:MiqAeClass) }
  let(:method_stub) { migration_stub(:MiqAeMethod) }
  let(:instance_stub) { migration_stub(:MiqAeInstance) }

  migration_context :up do
    it "handles domain without namespace" do
      dom = dom_stub.create!(:name => 'dom')

      migrate

      assert_domain(dom)
    end

    # nodes:
    # dom
    #   ns
    #     class1
    #       instance
    #       method
    it "handles domain with single namespace" do
      dom = dom_stub.create!(:name => 'dom')
      ns  = ns_stub.create!(:name => 'ns', :ancestry => dom.id.to_s)
      class1 = class_stub.create!(:namespace_id => ns.id)
      instance = instance_stub.create!(:class_id => class1.id)
      method = method_stub.create!(:class_id => class1.id)

      migrate

      assert_domain(dom)
      assert_object(ns, dom.id, ns.name)
      assert_object(class1, dom.id, "#{ns.name}/#{class1.name}")
      assert_object(instance, dom.id, "#{ns.name}/#{class1.name}/#{instance.name}")
      assert_object(method, dom.id, "#{ns.name}/#{class1.name}/#{method.name}")
    end

    # nodes:
    # dom
    #   ns1
    #     ns11
    #       class1
    #         instance
    it "handles domain with multiple namespaces" do
      dom = dom_stub.create!(:name => 'dom')
      ns1 = ns_stub.create!(:name => 'ns1', :ancestry => dom.id.to_s)
      ns11 = ns_stub.create!(:name => 'ns11', :ancestry => "#{dom.id}/#{ns1.id}")
      class1 = class_stub.create!(:namespace_id => ns11.id)
      instance = instance_stub.create!(:class_id => class1.id)

      migrate

      assert_domain(dom)
      assert_object(ns1, dom.id, ns1.name)
      assert_object(ns11, dom.id, "#{ns1.name}/#{ns11.name}")
      assert_object(class1, dom.id, "#{ns1.name}/#{ns11.name}/#{class1.name}")
      assert_object(instance, dom.id, "#{ns1.name}/#{ns11.name}/#{class1.name}/#{instance.name}")
    end

    # nodes:
    # dom
    #   ns1
    #     ns11
    #     ns12
    it "handles namespace without class" do
      dom = dom_stub.create!(:name => 'dom')
      ns1 = ns_stub.create!(:name => 'ns1', :ancestry => dom.id.to_s)
      ns11 = ns_stub.create!(:name => 'ns11', :ancestry => "#{dom.id}/#{ns1.id}")
      ns12 = ns_stub.create!(:name => 'ns12', :ancestry => "#{dom.id}/#{ns1.id}")

      migrate

      assert_domain(dom)
      assert_object(ns1, dom.id, ns1.name)
      assert_object(ns11, dom.id, "#{ns1.name}/#{ns11.name}")
      assert_object(ns12, dom.id, "#{ns1.name}/#{ns12.name}")
    end

    # nodes:
    # dom
    #   ns
    #     class1
    #       instance11
    #       method12
    #     class2
    #       instance21
    #       method22
    it "handles namespace with multiple classes" do
      dom = dom_stub.create!(:name => 'dom')
      ns  = ns_stub.create!(:name => 'ns', :ancestry => dom.id.to_s)
      class1 = class_stub.create!(:namespace_id => ns.id)
      instance11 = instance_stub.create!(:class_id => class1.id)
      method12 = method_stub.create!(:class_id => class1.id)
      class2 = class_stub.create!(:namespace_id => ns.id)
      instance21 = instance_stub.create!(:class_id => class2.id)
      method22 = method_stub.create!(:class_id => class2.id)

      migrate

      assert_domain(dom)
      assert_object(ns, dom.id, ns.name)
      assert_object(class1, dom.id, "#{ns.name}/#{class1.name}")
      assert_object(instance11, dom.id, "#{ns.name}/#{class1.name}/#{instance11.name}")
      assert_object(method12, dom.id, "#{ns.name}/#{class1.name}/#{method12.name}")
      assert_object(class2, dom.id, "#{ns.name}/#{class2.name}")
      assert_object(instance21, dom.id, "#{ns.name}/#{class2.name}/#{instance21.name}")
      assert_object(method22, dom.id, "#{ns.name}/#{class2.name}/#{method22.name}")
    end

    # nodes:  - Simulate the structure for '$' domain
    # dom
    #   class1
    #     method1
    it "handles class without namespace" do
      dom = dom_stub.create!(:name => 'dom')
      class1 = class_stub.create!(:name => 'class1', :namespace_id => dom.id)
      method1 = method_stub.create!(:name => 'method1', :class_id => class1.id)

      migrate

      assert_domain(dom)
      assert_object(class1, dom.id, class1.name)
      assert_object(method1, dom.id, "#{class1.name}/#{method1.name}")
    end
  end

  def assert_domain(domain)
    expect(domain.reload.domain_id).to be_nil
    expect(domain.relative_path).to be_nil
  end

  def assert_object(object, domain_id, relative_path)
    expect(object.reload.domain_id).to eq(domain_id)
    expect(object.relative_path).to eq(relative_path)
  end
end
