class UpdateCommentToVmsTableFormat < ActiveRecord::Migration[5.2]
  def up
    change_column_comment :vms, :format, "The format of the VM's disk, such as vmdk, qcow2, and tier1."
  end
end
