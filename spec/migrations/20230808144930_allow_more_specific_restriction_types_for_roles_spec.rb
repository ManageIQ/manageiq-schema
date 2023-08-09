require_migration

describe AllowMoreSpecificRestrictionTypesForRoles do
  let(:miq_user_role_stub) { migration_stub(:MiqUserRole) }

  migration_context :up do
    it "Existing Role with no restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false, :settings => nil)

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing read only Role with no restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true, :settings => nil)

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing read only Role with restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true,
                                                :settings  => {:restrictions => {:vms => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group}})
    end

    it "Existing Role with something else in settings is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:foo => {:bar => :user}})
    end

    it "Existing Role with ':vms=>:user_or_group' adds ':user_or_group' values for each new restriction" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(
        :settings => {
          :restrictions => {
            :vms                  => :user_or_group,
            :auth_key_pairs       => :user_or_group,
            :orchestration_stacks => :user_or_group,
            :services             => :user_or_group
          }
        }
      )
    end

    it "Existing Role with ':vms=>:user' adds ':user' values for each new restriction" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(
        :settings => {
          :restrictions => {
            :vms                  => :user,
            :auth_key_pairs       => :user,
            :orchestration_stacks => :user,
            :services             => :user
          }
        }
      )
    end

    it "Existing Role with something else in settings and ':vms=>:user' adds ':user' values for each new restriction" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}, :restrictions => {:vms => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(
        :settings => {
          :foo          => {:bar => :user},
          :restrictions => {
            :vms                  => :user,
            :auth_key_pairs       => :user,
            :orchestration_stacks => :user,
            :services             => :user
          }
        }
      )
    end
  end

  migration_context :down do
    it "Existing Role with no restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false, :settings => nil)

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing read only Role with no restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true, :settings => nil)

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role with something else in settings is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:foo => {:bar => :user}})
    end

    # auth_key_pairs
    it "Existing read only Role with restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :auth_key_pairs => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group, :auth_key_pairs => :user_or_group}})
    end

    it "Existing Role removes ':auth_key_pairs=>:user_or_group'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :auth_key_pairs => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group}})
    end

    it "Existing Role removes ':auth_key_pairs=>:user_or_group' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:auth_key_pairs => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role removes ':auth_key_pairs=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user, :auth_key_pairs => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user}})
    end

    it "Existing Role removes ':auth_key_pairs=>:user' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:auth_key_pairs => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing read only Role with restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :orchestration_stacks => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group, :orchestration_stacks => :user_or_group}})
    end

    it "Existing Role removes ':orchestration_stacks=>:user_or_group'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :orchestration_stacks => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group}})
    end

    it "Existing Role removes ':orchestration_stacks=>:user_or_group' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:orchestration_stacks => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role removes ':orchestration_stacks=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user, :orchestration_stacks => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user}})
    end

    it "Existing Role removes ':orchestration_stacks=>:user' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:orchestration_stacks => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing read only Role with restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :services => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group, :services => :user_or_group}})
    end

    it "Existing Role removes ':services=>:user_or_group'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :services => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group}})
    end

    it "Existing Role removes ':services=>:user_or_group' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:services => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role removes ':services=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user, :services => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user}})
    end

    it "Existing Role removes ':services=>:user' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:services => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role removes mix of all new restrictions" do
      miq_user_role = miq_user_role_stub.create(
        :read_only => false,
        :settings  => {
          :restrictions => {
            :vms                  => :user,
            :auth_key_pairs       => :user,
            :orchestration_stacks => :user,
            :services             => :user,
            :service_templates    => :user
          }
        }
      )

      migrate

      expect(miq_user_role.reload).to have_attributes(
        :read_only => false,
        :settings  => {
          :restrictions => {
            :vms               => :user,
            :service_templates => :user
          }
        }
      )
    end
  end
end
