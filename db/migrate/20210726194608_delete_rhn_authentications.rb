class DeleteRhnAuthentications < ActiveRecord::Migration[6.0]
  class Authentication < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time("removing authentication records for Red Hat Network") do
      Authentication.where(:authtype => %w[registration registration_http_proxy])
                    .destroy_all
    end
  end
end
