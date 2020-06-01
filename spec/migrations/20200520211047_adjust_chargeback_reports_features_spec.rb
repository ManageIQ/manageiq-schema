require_migration

describe AdjustChargebackReportsFeatures do
  let(:user_role_id) { anonymous_class_with_id_regions.id_in_region(1, anonymous_class_with_id_regions.my_region_number) }
  let(:feature_stub) { migration_stub :MiqProductFeature }
  let(:roles_feature_stub) { migration_stub :MiqRolesFeature }

  migration_context :up do
    describe 'product features update' do
      it 'also sets the chargeback_reports_view feature' do
        AdjustChargebackReportsFeatures::FEATURE_MAPPING.keys.each do |identifier|
          feature = feature_stub.create!(:identifier => identifier)
          roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)
        end

        migrate

        assigned = roles_feature_stub.where(:miq_user_role_id => user_role_id)
        expect(assigned.count).to eq(5)

        feature = feature_stub.find_by(:identifier => 'chargeback_reports_view')
        new_roles_feature = roles_feature_stub.where(:miq_user_role_id => user_role_id).where(:miq_product_feature_id => feature.id).first
        new_feature = feature_stub.find(new_roles_feature.miq_product_feature_id)
        expect(new_feature.identifier).to eq('chargeback_reports_view')
      end

      it 'renames the features' do
        view_feature1 = feature_stub.create!(:identifier => 'chargeback_download_csv')
        view_feature2 = feature_stub.create!(:identifier => 'chargeback_download_pdf')
        view_feature3 = feature_stub.create!(:identifier => 'chargeback_download_text')
        view_feature4 = feature_stub.create!(:identifier => 'chargeback_report_only')

        migrate

        expect(view_feature1.reload.identifier).to eq('chargeback_reports_download_csv')
        expect(view_feature2.reload.identifier).to eq('chargeback_reports_download_pdf')
        expect(view_feature3.reload.identifier).to eq('chargeback_reports_download_text')
        expect(view_feature4.reload.identifier).to eq('chargeback_reports_report_only')
      end
    end
  end

  migration_context :down do
    let!(:view_feature1) { feature_stub.create!(:identifier => 'chargeback_reports_download_csv') }
    let!(:view_feature2) { feature_stub.create!(:identifier => 'chargeback_reports_download_pdf') }
    let!(:view_feature3) { feature_stub.create!(:identifier => 'chargeback_reports_download_text') }
    let!(:view_feature4) { feature_stub.create!(:identifier => 'chargeback_reports_report_only') }

    describe 'product features update' do
      it 'sets the chargeback_reports_view feature' do
        feature = feature_stub.create!(:identifier => 'chargeback_reports')
        roles_feature_stub.create!(:miq_product_feature_id => feature.id, :miq_user_role_id => user_role_id)

        migrate

        assigned = roles_feature_stub.where(:miq_user_role_id => user_role_id)
        expect(assigned.count).to eq(5)

        expect(view_feature1.reload.identifier).to eq('chargeback_download_csv')
        expect(view_feature2.reload.identifier).to eq('chargeback_download_pdf')
        expect(view_feature3.reload.identifier).to eq('chargeback_download_text')
        expect(view_feature4.reload.identifier).to eq('chargeback_report_only')
      end

      it 'product feature is renamed when no role features are set' do
        migrate

        assigned = roles_feature_stub.where(:miq_user_role_id => user_role_id)
        expect(assigned.count).to eq(0)

        expect(view_feature1.reload.identifier).to eq('chargeback_download_csv')
        expect(view_feature2.reload.identifier).to eq('chargeback_download_pdf')
        expect(view_feature3.reload.identifier).to eq('chargeback_download_text')
        expect(view_feature4.reload.identifier).to eq('chargeback_report_only')
      end
    end
  end
end
