class AddCommentsToConversionHostsTable < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :conversion_hosts, "Conversion Hosts"

    change_column_comment :conversion_hosts, :address, "The IP address for the conversion host. "\
                          "If present, must be one of the associated resource's IP addresses."

    change_column_comment :conversion_hosts, :blockio_limit, "The block I/O (disk) limit that the conversion host may use."

    change_column_comment :conversion_hosts, :concurrent_transformation_limit, "The maximum number of concurrent "\
                          "transformation tasks the conversion host may undertake."

    change_column_comment :conversion_hosts, :cpu_limit, "The CPU percentage limit that the conversion host may use."

    change_column_comment :conversion_hosts, :created_at, "The timestamp the conversion host was "\
                          "added to the app inventory."

    change_column_comment :conversion_hosts, :id, "The internal database ID."

    change_column_comment :conversion_hosts, :max_concurrent_tasks, "The maximum number of concurrent "\
                          "tasks for the conversion host to be considered eligible."

    change_column_comment :conversion_hosts, :memory_limit, "The memory limit (in mb) that the conversion host may use."

    change_column_comment :conversion_hosts, :name, "A symbolic name for the conversion host."
    change_column_comment :conversion_hosts, :network_limit, "The maximum network (bandwidth) usage that the conversion host may use."
    change_column_comment :conversion_hosts, :resource_id, "The ID of the associated resource."
    change_column_comment :conversion_hosts, :resource_type, "The STI type of the associated resource."

    change_column_comment :conversion_hosts, :ssh_transport_supported, "Indicates whether or not "\
                          "ssh transport is supported from the appliance to the conversion host."

    change_column_comment :conversion_hosts, :type, "The STI type of the conversion host."

    change_column_comment :conversion_hosts, :updated_at, "The timestamp the conversion host was "\
                          "last updated within the appliance."

    change_column_comment :conversion_hosts, :vddk_transport_supported, "Indicates whether or not "\
                          "vddk transport is supported from the appliance to the conversion host."

    change_column_comment :conversion_hosts, :version, "The version of the v2v conversion tool on the conversion host."
  end
end
