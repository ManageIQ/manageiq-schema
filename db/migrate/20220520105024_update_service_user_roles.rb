class UpdateServiceUserRoles < ActiveRecord::Migration[6.0]
  class MiqUserRole < ActiveRecord::Base
    has_and_belongs_to_many :miq_product_features, :join_table => :miq_roles_features, :class_name => "UpdateServiceUserRoles::MiqProductFeature"
  end

  class MiqProductFeature < ActiveRecord::Base; end

  def up
    say_with_time("Correcting user created role feature sets") do
      service         = MiqProductFeature.find_by(:identifier => "service")
      service_accord  = MiqProductFeature.find_by(:identifier => "service_accord")

      if service_accord
        affected_user_roles(service, service_accord).each do |user_role|
          unless user_role.miq_product_features.include?(service)
            user_role.miq_product_features << service
          end
          if user_role.miq_product_features.include?(service_accord)
            user_role.miq_product_features.delete(service_accord)
          end

          user_role.save!
        end
      end
    end
  end

  def down
    # we do not know if the user started with service or service_accord roles
    # but both roles grant the same privilege, so this is ok
  end

  # Bring back all user roles that have service or service_accord features.
  # Only bring back the service and service_accord features for these roles.
  def affected_user_roles(*feature)
    MiqUserRole
      .includes(:miq_product_features)
      .where(:read_only => false, :miq_product_features => {:identifier => feature.map(&:identifier)})
  end
end
