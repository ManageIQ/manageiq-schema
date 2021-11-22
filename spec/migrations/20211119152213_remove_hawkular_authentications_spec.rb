require_migration

class RemoveHawkularAuthentications < ActiveRecord::Migration[6.0]
  class Authentication < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    belongs_to :resource, :polymorphic => true
  end

  class Endpoint < ActiveRecord::Base
    include ActiveRecord::IdRegions

    belongs_to :resource, :polymorphic => true
  end

  class ExtManagementSystem < ActiveRecord::Base
    include ActiveRecord::IdRegions
    self.inheritance_column = :_type_disabled

    has_many :authentications, :as => :resource
    has_many :endpoints, :as => :resource
  end
end

describe RemoveHawkularAuthentications do
  let(:auth_stub)     { migration_stub(:Authentication) }
  let(:endpoint_stub) { migration_stub(:Endpoint) }
  let(:ems_stub)      { migration_stub(:ExtManagementSystem) }

  migration_context :up do
    let(:kube) { ems_stub.create!(:type => "ManageIQ::Providers::Kubernetes::ContainerManager", :name => "kube") }

    before do
      auth_stub.create!(:type => "AuthToken", :authtype => "bearer", :userid => "_", :resource => kube)
      auth_stub.create!(:type => "AuthToken", :authtype => "hawkular", :userid => "_", :resource => kube)

      endpoint_stub.create!(:role => "default", :resource => kube)
      endpoint_stub.create!(:role => "hawkular", :resource => kube)
    end

    it "deletes hawkular authentication and endpoint records" do
      migrate

      kube.reload

      expect(kube.authentications.pluck(:authtype)).not_to include("hawkular")
      expect(kube.endpoints.pluck(:role)).not_to           include("hawkular")
    end

    it "doesn't delete other authentications and endpoints" do
      migrate

      kube.reload

      expect(kube.authentications.pluck(:authtype)).to include("bearer")
      expect(kube.endpoints.pluck(:role)).to           include("default")
    end
  end
end
