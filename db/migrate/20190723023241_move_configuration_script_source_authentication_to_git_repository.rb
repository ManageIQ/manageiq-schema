class MoveConfigurationScriptSourceAuthenticationToGitRepository < ActiveRecord::Migration[5.1]
  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class GitRepository < ActiveRecord::Base
    belongs_to :authentication, :class_name => parent::Authentication.name
  end

  class ConfigurationScriptSource < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    belongs_to :authentication, :class_name => parent::Authentication.name
    belongs_to :git_repository, :class_name => parent::GitRepository.name
  end

  def up
    say_with_time("Moving embedded ansible configuration_script_source authentication to git_repository") do
      ConfigurationScriptSource.where(:type => "ManageIQ::Providers::EmbeddedAnsible::AutomationManager::ConfigurationScriptSource").each do |css|
        unless css.git_repository
          css.update!(:git_repository => GitRepository.create!(:url => scm_url))
        end

        if css.authentication
          css.git_repository.update!(:authentication => css.authentication)
          css.update!(:authentication_id => nil)  # TODO: Do we need this?
        end
      end
    end
  end
end
