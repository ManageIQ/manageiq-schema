class RemoveHostProvisioning < ActiveRecord::Migration[5.0]
  class MiqApproval < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :miq_request, :class_name => 'RemoveHostProvisioning::MiqRequest'
  end

  class MiqRequest < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    has_many :miq_approvals, :dependent => :destroy, :class_name => 'RemoveHostProvisioning::MiqApproval'
  end

  class MiqRequestTask < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("Delete Host Provision Requests and Tasks") do
      MiqRequest.where(:type => :MiqHostProvisionRequest).destroy_all
      MiqRequestTask.where(:type => :MiqHostProvision).destroy_all
    end
  end
end
