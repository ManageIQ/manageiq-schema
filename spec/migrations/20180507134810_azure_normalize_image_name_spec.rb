require_migration

describe AzureNormalizeImageName do
  let(:vm_stub) { migration_stub :VmOrTemplate }

  migration_context :up do
    it "removes ./ from image names" do
      template = vm_stub.create!(
        :name    => './foo',
        :type    => 'ManageIQ::Providers::Azure::CloudManager::Template',
        :uid_ems => 'http://foo.bar.com'
      )

      migrate
      template.reload

      expect(template.name).to eql('foo')
    end

    it "does not affect images that do not have a ./ in them" do
      template = vm_stub.create!(
        :name    => 'foo/bar',
        :type    => 'ManageIQ::Providers::Azure::CloudManager::Template',
        :uid_ems => 'http://foo.bar.com'
      )

      migrate
      template.reload

      expect(template.name).to eql('foo/bar')
    end

    it "does not affect other providers" do
      template = vm_stub.create!(
        :name    => './foo',
        :type    => 'ManageIQ::Providers::Amazon::CloudManager::Template',
        :uid_ems => 'http://foo.bar.com'
      )

      migrate
      template.reload

      expect(template.name).to eql('./foo')
    end
  end

  migration_context :down do
    it "restores ./ to unmanaged images" do
      template = vm_stub.create!(
        :name    => 'foo',
        :type    => 'ManageIQ::Providers::Azure::CloudManager::Template',
        :uid_ems => 'http://foo.bar.com'
      )

      migrate
      template.reload

      expect(template.name).to eql('./foo')
    end

    it "does not affect unmanaged images" do
      template = vm_stub.create!(
        :name    => 'bar',
        :type    => 'ManageIQ::Providers::Azure::CloudManager::Template',
        :uid_ems => '/subscriptions/whatever'
      )

      migrate
      template.reload

      expect(template.name).to eql('bar')
    end

    it "does not affect other providers" do
      template = vm_stub.create!(
        :name    => 'bar',
        :type    => 'ManageIQ::Providers::Amazon::CloudManager::Template',
        :uid_ems => 'http://foo.bar.com'
      )

      migrate
      template.reload

      expect(template.name).to eql('bar')
    end
  end
end
