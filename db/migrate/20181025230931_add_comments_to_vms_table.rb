class AddCommentsToVmsTable < ActiveRecord::Migration[5.0]
  def up
    change_table_comment :vms, "Virtual Machines and Templates"

    change_column_comment :vms, :autostart, "Indicates whether or not the VM is set to autostart."
    change_column_comment :vms, :availability_zone_id, "ID of the availability zone that the VM is part of."
    change_column_comment :vms, :busy, "Indicates whether or not the VM is being scanned for SmartState analysis. Deprecated."
    change_column_comment :vms, :boot_time, "The last time the VM was started."
    change_column_comment :vms, :cloud, "Indicates whether or not the VM/Template is cloud or infra."
    change_column_comment :vms, :cloud_network_id, "ID of the cloud (virtual) network the VM/Template is associated with."
    change_column_comment :vms, :cloud_subnet_id, "Subnet ID associated with the VM."
    change_column_comment :vms, :cloud_tenant_id, "ID of the cloud tenant associated with the VM."
    change_column_comment :vms, :config_xml, "The VM or Template configuration in XML format. Deprecated."
    change_column_comment :vms, :connection_state, "Indicates the connection state of the VM, e.g. connected, disconnected, etc."
    change_column_comment :vms, :cpu_affinity, "A comma separated list of host CPUs to schedule the VM on."
    change_column_comment :vms, :cpu_hot_add_enabled, "Indicates if CPUs can be added to the VM while it is powered on."
    change_column_comment :vms, :cpu_hot_remove_enabled, "Indicates if a CPU can be removed from a VM while powered on."
    change_column_comment :vms, :cpu_limit, "The CPU utilization limit for the VM."
    change_column_comment :vms, :cpu_reserve, "Amount of CPU that is guaranteed available for the VM."

    change_column_comment :vms, :cpu_reserve_expand, "Amount the CPU can grow beyond its normal limits if there "\
                                                     "are unreserved resources available."

    change_column_comment :vms, :cpu_shares, "The number of CPU shares allocated. Used to determine resource allocation "\
                                             "in case of resource contention."

    change_column_comment :vms, :cpu_shares_level, "CPU shares allocation level."
    change_column_comment :vms, :created_on, "The timestamp the VM was added to the app inventory."
    change_column_comment :vms, :deprecated, "Indicates whether or not a template is deprecated."
    change_column_comment :vms, :description, "A description of the VM that is typically set by the provider, but may also be edited."
    change_column_comment :vms, :ems_created_on, "The timestamp the VM or Templated was created on the EMS itself."
    change_column_comment :vms, :ems_id, "ID of the ExtManagementSystem associated with the VM."

    change_column_comment :vms, :evm_owner_id, "Typically, the ID of the user that provisioned the VM (if provisioned through the app)."\
                                               "Can also be set via inventory, the UI or Automate."

    change_column_comment :vms, :ems_ref, "A native unique reference for the VM within the EMS."
    change_column_comment :vms, :ems_ref_obj, "A YAML serialized version of the ems_ref."
    change_column_comment :vms, :ems_cluster_id, "ID of associated cluster."

    change_column_comment :vms, :fault_tolerance, "Indicates whether or not the VM is fault tolerant, i.e. if one host "\
                                                  "crashes it will immediately pick up on another host in the cluster."

    change_column_comment :vms, :flavor_id, "ID of associated flavor."
    change_column_comment :vms, :format, "The format of the VM's disk, such as VMDK. Deprecated."
    change_column_comment :vms, :guid, "A value used to uniquely identify the VM internally."
    change_column_comment :vms, :id, "The internal database ID."
    change_column_comment :vms, :host_id, "ID of the host that the VM/Template resides on."
    change_column_comment :vms, :last_perf_capture_on, "Timestamp for last performance metrics capture."
    change_column_comment :vms, :last_scan_on, "Timestamp for last SmartState analysis scan."
    change_column_comment :vms, :last_scan_attempt_on, "Timestamp for last attempt to perform SmartState Analysis."
    change_column_comment :vms, :last_sync_on, "Timestamp for last SmartState analysis synchronization."

    change_column_comment :vms, :linked_clone, "Indicates whether the VM is a linked clone, i.e its disk is a referencing "\
                                               "disk pointing to snapshot of another VM."

    change_column_comment :vms, :location, "The location of the VM, or its underlying storage."
    change_column_comment :vms, :memory_hot_add_enabled, "Indicates whether or not memory can be hot added to the running VM."

    change_column_comment :vms, :memory_hot_add_increment, "Memory in MB that can be added to a running VM must be in "\
                                                           "increments of this value."

    change_column_comment :vms, :memory_hot_add_limit, "The maximum amount of memory, in MB, that can be added to a running VM."
    change_column_comment :vms, :memory_limit, "The absolute memory limit for the VM."
    change_column_comment :vms, :memory_reserve, "Amount of memory that is guaranteed available for the VM."

    change_column_comment :vms, :memory_reserve_expand, "Amount the memory can grow beyond its normal limits if there "\
                                                     "are unreserved resources available."

    change_column_comment :vms, :memory_shares, "The number of memory shares allocated. Used to determine resource allocation "\
                                             "in case of resource contention."

    change_column_comment :vms, :memory_shares_level, "Memory shares allocation level."

    change_column_comment :vms, :miq_group_id, "ID of the MIQ Group owner."
    change_column_comment :vms, :name, "The name of the VM/Template."
    change_column_comment :vms, :orchestration_stack_id, "ID of the orchestration stack associated with the VM."
    change_column_comment :vms, :power_state, "The current power state, typically 'on' or 'off'."
    change_column_comment :vms, :previous_state, "The previous power state change."
    change_column_comment :vms, :publicly_available, "Indicates whether the VM is public or private."
    change_column_comment :vms, :raw_power_state, "The power state refreshed from the EMS."
    change_column_comment :vms, :registered, "Indicates whether the VM registered to a Provider. Deprecated."
    change_column_comment :vms, :resource_group_id, "ID of the resource group that the VM/Template belongs to."
    change_column_comment :vms, :retired, "Indicates whether or not the VM is retired."
    change_column_comment :vms, :retirement_last_warn, "Date of last retirement warning."
    change_column_comment :vms, :retirement_requester, "Userid of the user who requested retirement."
    change_column_comment :vms, :retirement_state, "The current retirement state."
    change_column_comment :vms, :retirement_warn, "Warning message when VM was put into retirement."
    change_column_comment :vms, :retires_on, "Timestamp the VM is to be retired."
    change_column_comment :vms, :smart, "Indicates whether or not smart proxy is enabled. Deprecated."
    change_column_comment :vms, :standby_action, "Action taken when VM is put into standby mode."
    change_column_comment :vms, :storage_id, "ID of the storage object associated with the VM."
    change_column_comment :vms, :storage_profile_id, "ID of the storage profile associated with the VM."
    change_column_comment :vms, :state_changed_on, "The timestamp of the last power state change."
    change_column_comment :vms, :template, "Indicates whether this is a VM or template."
    change_column_comment :vms, :tenant_id, "ID of the tenant associated with the VM."
    change_column_comment :vms, :tools_status, "Status of guest tools."
    change_column_comment :vms, :type, "An internal class name that includes the provider type."
    change_column_comment :vms, :uid_ems, "A globally unique reference for the VM across EMS."
    change_column_comment :vms, :updated_on, "The last timestamp the VM was modified within the app."
    change_column_comment :vms, :vendor, "The vendor for the VM, e.g. azure, amazon, etc."
    change_column_comment :vms, :version, "The version of the VM definition."
    change_column_comment :vms, :vnc_port, "Port or port range used for VNC connections."
  end
end
