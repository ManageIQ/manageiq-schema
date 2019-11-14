require_migration

describe RemoveMiqwidgetRss do
  migration_context :up do
    let(:miq_widget) { migration_stub :MiqWidget }

    it 'does delete only MiqWidget with content_type set to RSS' do
      miq_widget.create!(:content_type => 'rss')
      miq_widget.create!(:content_type => 'menu')
      miq_widget.create!(:content_type => 'chart')
      miq_widget.create!(:content_type => 'report')

      migrate

      expect(miq_widget.where(:content_type => "rss").count).to eq 0
      expect(miq_widget.where(:content_type => "menu").count).to eq 1
      expect(miq_widget.where(:content_type => "chart").count).to eq 1
      expect(miq_widget.where(:content_type => "report").count).to eq 1
    end
  end
end
