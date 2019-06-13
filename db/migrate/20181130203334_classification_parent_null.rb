class ClassificationParentNull < ActiveRecord::Migration[5.0]
  class Classification < ActiveRecord::Base
  end

  def up
    change_column_default(:classifications, :parent_id, nil)
    Classification.where(:parent_id => 0).update_all(:parent_id => nil)
  end

  def down
    change_column_default(:classifications, :parent_id, 0)
    Classification.where(:parent_id => nil).update_all(:parent_id => 0)
  end
end
