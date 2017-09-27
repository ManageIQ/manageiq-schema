class MigrateDialogFieldAssociationsToUseNewRelationship < ActiveRecord::Migration[5.0]
  class Dialog < ActiveRecord::Base
  end

  class DialogTab < ActiveRecord::Base
    belongs_to :dialog, :class_name => "MigrateDialogFieldAssociationsToUseNewRelationship::Dialog"
  end

  class DialogGroup < ActiveRecord::Base
    belongs_to :dialog_tab, :class_name => "MigrateDialogFieldAssociationsToUseNewRelationship::DialogTab"
  end

  class DialogField < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
    belongs_to :dialog_group, :class_name => "MigrateDialogFieldAssociationsToUseNewRelationship::DialogGroup"
  end

  class DialogFieldAssociation < ActiveRecord::Base
  end

  def up
    say_with_time("Migrating existing dialog field associations to new relationship") do
      dialog_with_fields.each do |_dialog, fields|
        dialog_triggers = dialog_fields_with_trigger_auto_refresh(fields).sort_by! { |trigger| trigger[:position] }
        dialog_responders = dialog_fields_with_auto_refresh(fields)
        dialog_triggers.each_with_index do |trigger, index|
          specific_responders = dialog_responders.select { |responder| responder_range(trigger, trigger[index + 1]).cover?(responder[:position]) }
          set_associations(trigger, specific_responders)
        end
      end
    end
  end

  def down
    DialogFieldAssociation.delete_all
  end

  private

  def absolute_position(dialog_fields)
    dialog_fields.collect do |f|
      field_position = f.position
      dialog_group_position = f.dialog_group.position
      dialog_tab_position = f.dialog_group.dialog_tab.position
      index = field_position + dialog_group_position * 1000 + dialog_tab_position * 100_000
      {:id => f.id, :position => index}
    end
  end

  def dialog_fields_with_auto_refresh(dialog_fields)
    absolute_position(dialog_fields.select(&:auto_refresh))
  end

  def dialog_fields_with_trigger_auto_refresh(dialog_fields)
    absolute_position(dialog_fields.select(&:trigger_auto_refresh))
  end

  def responder_range(trigger_min, trigger_max)
    min = trigger_min[:position] + 1
    max = trigger_max.present? ? trigger_max[:position] - 1 : 100_000_000
    (min..max)
  end

  def set_associations(trigger, specific_responders)
    specific_responders.each { |responder| DialogFieldAssociation.create!(:trigger_id => trigger[:id], :respond_id => responder[:id]) }
  end

  def dialog_with_fields
    DialogField
      .where(:auto_refresh => true)
      .or(DialogField.where(:trigger_auto_refresh => true))
      .includes(:dialog_group => {:dialog_tab => :dialog})
      .group_by { |f| f.dialog_group.try(:dialog_tab).try(:dialog) }
      .except(nil)
  end
end
