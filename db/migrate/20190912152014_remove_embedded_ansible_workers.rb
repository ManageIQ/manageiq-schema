class RemoveEmbeddedAnsibleWorkers < ActiveRecord::Migration[5.1]
  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    say_with_time "Remove EmbeddedAnsibleWorker records where the model was removed" do
      MiqWorker.where(:type => "EmbeddedAnsibleWorker").delete_all
    end
  end
end
