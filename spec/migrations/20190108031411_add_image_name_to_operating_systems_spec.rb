require_migration

describe AddImageNameToOperatingSystems do
  let(:host_stub)             { migration_stub(:Host) }
  let(:hardware_stub)         { migration_stub(:Hardware) }
  let(:vm_or_template_stub)   { migration_stub(:VmOrTemplate) }
  let(:computer_system_stub)  { migration_stub(:ComputerSystem) }
  let(:operating_system_stub) { migration_stub(:OperatingSystem) }

  # rubocop:disable Layout/SpaceInsideArrayPercentLiteral
  let(:test_os_values) do
    [
      %w[an_amazing_undiscovered_os unknown],
      %w[centos-7                   linux_centos],
      %w[debian-8                   linux_debian],
      %w[opensuse-13                linux_suse],
      %w[sles-12                    linux_suse],
      %w[rhel-7                     linux_redhat],
      %w[ubuntu-15-10               linux_ubuntu],
      %w[windows-2012-r2            windows_generic],
      %w[vmnix-x86                  linux_esx],
      %w[vista                      windows_generic],
      %w[coreos-cloud               linux_coreos]
    ]
  end
  # rubocop:enable Layout/SpaceInsideArrayPercentLiteral

  def record_with_os(klass, os_attributes = nil, record_attributes = {:name => ""}, hardware_attributes = nil)
    os_record = operating_system_stub.new(os_attributes) if os_attributes

    if klass == operating_system_stub
      os_record.save!
      os_record
    else
      record = klass.new
      record_attributes.each do |attr, val|
        record.send("#{attr}=", val) if record.respond_to?(attr)
      end

      record.operating_system = os_record
      record.hardware         = hardware_stub.new(hardware_attributes) if hardware_attributes
      record.save!
      record
    end
  end

  # Runs tests for class type to confirm they
  def test_for_klass(klass)
    begin
      # This callback is necessary after the migration, but fails when the
      # column doesn't eixst (prior to the migration).  Removing it and
      # re-enabling it after the migration.
      operating_system_stub.skip_callback(:save, :before, :update_platform_and_image_name)

      distribution_based = []
      product_type_based = []
      product_name_based = []
      fallback_records   = []

      test_os_values.each do |(value, _)|
        distribution_based << record_with_os(klass, :distribution => value)
        product_type_based << record_with_os(klass, :product_type => value)
        product_name_based << record_with_os(klass, :product_name => value)
      end

      # favor distribution over product_type
      fallback_records << record_with_os(klass, :distribution => "rhel-7", :product_type => "centos-7")
      # falls back to os.product_type if invalid os.distribution
      fallback_records << record_with_os(klass, :distribution => "undiscovered-7", :product_type => "rhel-7")
      # falls back to os.product_name
      fallback_records << record_with_os(klass, :distribution => "undiscovered-7", :product_name => "rhel-7")
      # falls back to hardware.guest_os
      fallback_records << record_with_os(klass, {:distribution => "undiscovered-7"}, {}, {:guest_os => "rhel-7"})
      # falls back to Host#user_assigned_os
      fallback_records << record_with_os(klass, {:distribution => "undiscovered-7"}, {:user_assigned_os => "rhel-7"})
    ensure
      # If the any of the above fails, make sure we re-enable callbacks so
      # subsequent specs don't fail trying to skip this callback when it
      # doesn't exist.
      operating_system_stub.set_callback(:save, :before, :update_platform_and_image_name)
    end

    migrate

    test_os_values.each.with_index do |(_, image_name), index|
      [distribution_based, product_type_based, product_name_based].each do |record_list|
        os_record = record_list[index]
        os_record.reload
        os_record = os_record.operating_system if os_record.respond_to?(:operating_system)

        expect(os_record.image_name).to eq(image_name)
        expect(os_record.platform).to   eq(image_name.split("_").first)
      end
    end

    fallback_records.each(&:reload)

    platform, image_name = %w[linux linux_redhat]
    fallback_records.each.with_index do |record, index|
      os_record = record
      os_record = os_record.operating_system if os_record.respond_to?(:operating_system)

      # OperatingSystem records don't have a hardware relation, so this will be
      # a "unknown" OS
      platform, image_name = %w[unknown unknown] if index == 3 && klass == operating_system_stub

      # Both ComputerSystem and VmOrTemplate don't have :user_assigned_os, so
      # these will return "unknown" instead of what we (tried to) set.
      platform, image_name = %w[unknown unknown] if index == 4 && klass != host_stub

      expect(os_record.image_name).to eq(image_name)
      expect(os_record.platform).to   eq(platform)
    end
  end

  migration_context :up do
    it "adds the columns" do
      before_columns = operating_system_stub.columns.map(&:name)
      expect(before_columns).to_not include("platform")
      expect(before_columns).to_not include("image_name")

      migrate

      after_columns = operating_system_stub.columns.map(&:name)
      expect(after_columns).to include("platform")
      expect(after_columns).to include("image_name")
    end

    it "updates OperatingSystem for Host records" do
      test_for_klass host_stub
    end

    it "updates OperatingSystem for VmOrTemplate records" do
      test_for_klass vm_or_template_stub
    end

    it "updates OperatingSystem for ComputerSystem records" do
      test_for_klass computer_system_stub
    end

    it "updates orphaned OperatingSystem records" do
      test_for_klass operating_system_stub
    end
  end

  migration_context :down do
    it "adds the columns" do
      before_columns = operating_system_stub.columns.map(&:name)
      expect(before_columns).to include("platform")
      expect(before_columns).to include("image_name")

      migrate

      after_columns = operating_system_stub.columns.map(&:name)
      expect(after_columns).to_not include("platform")
      expect(after_columns).to_not include("image_name")
    end
  end
end
