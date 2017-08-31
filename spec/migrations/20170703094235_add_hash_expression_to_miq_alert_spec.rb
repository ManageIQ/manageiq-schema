require_migration

describe AddHashExpressionToMiqAlert do
  migration_context :up do
    let(:miq_alert_stub) { migration_stub(:MiqAlert) }

    it 'alert with hash expression has nil miq_expression and hash_expression is set' do
      hash_expression = '---\n:mode: internal\n'
      alert = miq_alert_stub.create!(:description => 'Test Alert', :expression => hash_expression)

      migrate

      alert.reload
      expect(alert.hash_expression).to eq(hash_expression)
      expect(alert.miq_expression).to be_nil
      expect { alert.expression }.to raise_error(NoMethodError)
    end

    it 'alert with non hash expression has nil hash_expression and miq_expression is set' do
      expression = '--- !ruby/object:MiqExpression
      exp:
        "=":
          field: Vm-platform
          value: windows
      '
      alert = miq_alert_stub.create!(:description => 'Test Alert', :expression => expression)

      migrate

      alert.reload
      expect(alert.hash_expression).to be_nil
      expect(alert.miq_expression).to eq(expression)
      expect { alert.expression }.to raise_error(NoMethodError)
    end
  end

  migration_context :down do
    let(:miq_alert_stub) { migration_stub(:MiqAlert) }

    it 'expression is set for alert with hash expression' do
      hash_expression = '---\n:mode: internal\n'
      alert = miq_alert_stub.create!(:description => 'Test Alert', :hash_expression => hash_expression)

      migrate

      alert.reload
      expect(alert.expression).to eq(hash_expression)
      expect { alert.hash_expression }.to raise_error(NoMethodError)
      expect { alert.miq_expression }.to raise_error(NoMethodError)
    end

    it 'expression is set for alert with non hash expression' do
      expression = '--- !ruby/object:MiqExpression
      exp:
        "=":
          field: Vm-platform
          value: windows
      '
      alert = miq_alert_stub.create!(:description => 'Test Alert', :miq_expression => expression)

      migrate

      alert.reload
      expect(alert.expression).to eq(expression)
      expect { alert.hash_expression }.to raise_error(NoMethodError)
      expect { alert.miq_expression }.to raise_error(NoMethodError)
    end
  end
end
