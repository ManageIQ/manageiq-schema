class AddImageNameToOperatingSystems < ActiveRecord::Migration[5.0]
  include MigrationHelper

  StubOperatingSystemObj = Struct.new(:operating_system) do
    attr_reader :hardware # always nil
    def name
      ""
    end
  end

  class OperatingSystem < ActiveRecord::Base
    belongs_to :host
    belongs_to :vm_or_template
    belongs_to :computer_system

    # Using a `before_save` here since this is the mechanism that will be used
    # in the app.  Causes a bit of issues in the specs, but proves that this
    # would work moving forward.
    before_save :update_platform_and_image_name

    def update_platform_and_image_name
      obj = case # rubocop:disable Style/EmptyCaseCondition
            when host_id            then host
            when vm_or_template_id  then vm_or_template
            when computer_system_id then computer_system
            else
              StubOperatingSystemObj.new(self)
            end

      if obj
        self.image_name = self.class.image_name(obj)
        self.platform   = self.image_name.split("_").first # rubocop:disable Style/RedundantSelf
      end
    end

    # rubocop:disable Style/PercentLiteralDelimiters
    @@os_map = [ # rubocop:disable Style/ClassVars
      ["windows_generic", %w(winnetenterprise w2k3 win2k3 server2003 winnetstandard servernt)],
      ["windows_generic", %w(winxppro winxp)],
      ["windows_generic", %w(vista longhorn)],
      ["windows_generic", %w(win2k win2000)],
      ["windows_generic", %w(microsoft windows winnt)],
      ["linux_ubuntu",    %w(ubuntu)],
      ["linux_chrome",    %w(chromeos)],
      ["linux_chromium",  %w(chromiumos)],
      ["linux_suse",      %w(suse sles)],
      ["linux_redhat",    %w(redhat rhel)],
      ["linux_fedora",    %w(fedora)],
      ["linux_gentoo",    %w(gentoo)],
      ["linux_centos",    %w(centos)],
      ["linux_debian",    %w(debian)],
      ["linux_coreos",    %w(coreos)],
      ["linux_esx",       %w(vmnixx86 vmwareesxserver esxserver vmwareesxi)],
      ["linux_solaris",   %w(solaris)],
      ["linux_generic",   %w(linux)]
    ]
    # rubocop:enable Style/PercentLiteralDelimiters

    # rubocop:disable Naming/VariableName
    def self.normalize_os_name(osName) # rubocop:disable Naming/UncommunicativeMethodParamName
      findStr = osName.downcase.gsub(/[^a-z0-9]/, "")
      @@os_map.each do |a|
        a[1].each do |n|
          return a[0] unless findStr.index(n).nil?
        end
      end
      "unknown"
    end
    # rubocop:enable Naming/VariableName

    # rubocop:disable Naming/VariableName
    def self.image_name(obj)
      osName = nil

      # Select most accurate name field
      os = obj.operating_system
      if os
        # check the given field names for possible matching value
        osName = [:distribution, :product_type, :product_name].each do |field|
          os_field = os.send(field)
          break(os_field) if os_field && OperatingSystem.normalize_os_name(os_field) != "unknown"
        end

        # If the normalized name comes back as unknown, nil out the value so we can get it from another field
        if osName.kind_of?(String)
          osName = nil if OperatingSystem.normalize_os_name(osName) == "unknown"
        else
          osName = nil
        end
      end

      # If the OS Name is still blank check the 'user_assigned_os'
      if osName.nil? && obj.respond_to?(:user_assigned_os) && obj.user_assigned_os
        osName = obj.user_assigned_os
      end

      # If the OS Name is still blank check the hardware table
      if osName.nil? && obj.hardware && !obj.hardware.guest_os.nil?
        osName = obj.hardware.guest_os
        # if we get generic linux or unknown back see if the vm name is better
        norm_os = OperatingSystem.normalize_os_name(osName)
        if norm_os == "linux_generic" || norm_os == "unknown" # rubocop:disable Style/MultipleComparison
          vm_name = OperatingSystem.normalize_os_name(obj.name)
          return vm_name unless vm_name == "unknown"
        end
      end

      # If the OS Name is still blank use the name field from the object given
      osName = obj.name if osName.nil? && obj.respond_to?(:name)

      # Normalize name to match existing icons
      OperatingSystem.normalize_os_name(osName || "")
    end
    # rubocop:enable Naming/VariableName
  end

  class VmOrTemplate < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
    self.table_name = 'vms'

    has_one :operating_system
    has_one :hardware
  end

  class Host < ActiveRecord::Base
    self.inheritance_column = :_type_disabled

    has_one :operating_system
    has_one :hardware
  end

  class ComputerSystem < ActiveRecord::Base
    has_one :operating_system
    has_one :hardware
  end

  class Hardware < ActiveRecord::Base
  end

  def up
    add_column :operating_systems, :platform,   :string
    add_column :operating_systems, :image_name, :string

    say_with_time("Updating platform and image_name in OperatingSystems") do
      base_relation = OperatingSystem.all
      say_batch_started(base_relation.size)

      base_relation.find_in_batches do |group|
        group.each(&:save)
        say_batch_processed(group.count)
      end
    end
  end

  def down
    remove_column :operating_systems, :platform,   :string
    remove_column :operating_systems, :image_name, :string
  end
end
