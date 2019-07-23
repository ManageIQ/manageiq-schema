class AddAuthenticationIdToGitRepository < ActiveRecord::Migration[5.1]
  def change
    add_column :git_repositories, :authentication_id, :bigint
  end
end
