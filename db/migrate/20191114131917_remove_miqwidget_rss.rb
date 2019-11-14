class RemoveMiqwidgetRss < ActiveRecord::Migration[5.1]
  class MiqWidget < ActiveRecord::Base; end

  def up
    MiqWidget.where(:content_type => 'rss').delete_all
  end
end
