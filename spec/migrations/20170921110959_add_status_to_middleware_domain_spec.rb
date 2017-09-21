require_migration

describe AddStatusToMiddlewareDomain do
  let(:middleware_domain_stub) { migration_stub(:MiddlewareDomain) }

  migration_context :up do
    it_behaves_like 'column addition', :status, :MiddlewareDomain
  end

  migration_context :down do
    it_behaves_like 'column deletion', :status, :MiddlewareDomain
  end
end
