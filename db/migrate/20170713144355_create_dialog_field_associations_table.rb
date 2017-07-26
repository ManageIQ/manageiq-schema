class CreateDialogFieldAssociationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :dialog_field_associations do |t|
      t.bigint :trigger_id
      t.bigint :respond_id
    end
  end
end
