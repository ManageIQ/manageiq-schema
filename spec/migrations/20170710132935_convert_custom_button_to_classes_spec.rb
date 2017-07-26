require_migration

describe ConvertCustomButtonToClasses do
  context 'CustomButton' do
    let(:params) { custom_button.options }
    let!(:custom_button) { migration_stub(:CustomButton).create!(create_params) }

    migration_context :up do
      let(:create_params) { {:options => {:button_image => 1} } }

      it 'sets the image class and color' do
        migrate
        custom_button.reload

        expect(params).to have_key(:button_icon)
        expect(params).to have_key(:button_color)
        expect(params).not_to have_key(:button_image)
      end

      context 'when a button has the default color' do
        let(:create_params) { {:options => {:button_image => 6} } }
        it 'sets the image class only' do
          migrate
          custom_button.reload

          expect(params).to have_key(:button_icon)
          expect(params).not_to have_key(:button_color)
        end
      end
    end

    migration_context :down do
      let(:create_params) { {:options => {:button_icon => 'ff ff-hexagon', :button_color => '#2d7623'}} }

      it 'reverts the image to a number' do
        migrate
        custom_button.reload

        expect(params).to have_key(:button_image)
        expect(params).not_to have_key(:button_icon)
        expect(params).not_to have_key(:button_color)
      end
    end
  end

  context 'CustomButtonSet' do
    let(:params) { custom_button.set_data }
    let!(:custom_button) { migration_stub(:MiqSet).create!(create_params) }

    migration_context :up do
      let(:create_params) { {:set_data => {:button_image => 1}, :set_type => 'CustomButtonSet'} }

      it 'sets the image class and color' do
        migrate
        custom_button.reload

        expect(params).to have_key(:button_icon)
        expect(params).to have_key(:button_color)
        expect(params).not_to have_key(:button_image)
      end

      context 'when a button set has the default color' do
        let(:create_params) { {:set_data => {:button_image => 6}, :set_type => 'CustomButtonSet'} }

        it 'sets the image class only' do
          migrate
          custom_button.reload

          expect(params).to have_key(:button_icon)
          expect(params).not_to have_key(:button_color)
        end
      end
    end

    migration_context :down do
      let(:create_params) { {:set_data => {:button_icon => 'ff ff-hexagon', :button_color => '#2d7623'}, :set_type => 'CustomButtonSet'} }

      it 'reverts the image to a number' do
        migrate
        custom_button.reload

        expect(params).to have_key(:button_image)
        expect(params).not_to have_key(:button_icon)
        expect(params).not_to have_key(:button_color)
      end
    end
  end
end
