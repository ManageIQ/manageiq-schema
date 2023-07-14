require_migration

describe SeparateRoleAccessRestrictionsForServiceTemplates do
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

    it "Existing Role with ':vms=>:user_or_group' adds ':service_templates=>:user_or_group'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group, :service_templates => :user_or_group}})
    end

    it "Existing Role with ':vms=>:user' adds ':service_templates=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user, :service_templates => :user}})
    end

    it "Existing Role with something else in settings is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:foo => {:bar => :user}})
    end

    it "Existing Role with something else in settings and ':vms=>:user' adds ':service_templates=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}, :restrictions => {:vms => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:foo => {:bar => :user}, :restrictions => {:vms => :user, :service_templates => :user}})
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

    it "Existing read only Role with restrictions is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => true,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :service_templates => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group, :service_templates => :user_or_group}})
    end

    it "Existing Role removes ':service_templates=>:user_or_group'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user_or_group, :service_templates => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user_or_group}})
    end

    it "Existing Role removes ':service_templates=>:user_or_group' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:service_templates => :user_or_group}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role removes ':service_templates=>:user'" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:vms => :user, :service_templates => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:restrictions => {:vms => :user}})
    end

    it "Existing Role removes ':service_templates=>:user' (no :vms restrictions)" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:restrictions => {:service_templates => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => nil)
    end

    it "Existing Role with something else in settings is unchanged" do
      miq_user_role = miq_user_role_stub.create(:read_only => false,
                                                :settings  => {:foo => {:bar => :user}})

      migrate

      expect(miq_user_role.reload).to have_attributes(:settings => {:foo => {:bar => :user}})
    end
  end
end
