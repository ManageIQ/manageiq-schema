class DialogFieldLoadValuesOnInit < ActiveRecord::Migration[5.0]
  class DialogField < ActiveRecord::Base
    self.inheritance_column = :_type_disabled # disable STI
  end

  def up
    say_with_time("Updating Dialog Fields") do
      DialogField.where(:show_refresh_button => [false, nil]).update_all('load_values_on_init = true')
    end
  end
end
