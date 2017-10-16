require_migration

describe DropConditionModifier do
  let(:condition_stub) { migration_stub(:Condition) }

  migration_context :up do
    it "reverse the expression if :modifier = 'deny'" do
      expression = <<~EXPR
        --- !ruby/object:MiqExpression
        exp:
          ENDS WITH:
            field: ContainerImage-name
            value: "/image-inspector"
      EXPR

      skipped_expression = <<~EXPR
        ---
        exp:
          ENDS WITH:
            field: ContainerImage-name
            value: "/image-inspector"
      EXPR

      expected_expression = <<~EXPR
        --- !ruby/object:MiqExpression
        exp:
          not:
            ENDS WITH:
              field: ContainerImage-name
              value: "/image-inspector"
      EXPR

      condition_changed = condition_stub.create!(:modifier => 'deny', :expression => expression)
      condition_skipped = condition_stub.create!(:modifier => 'deny', :expression => skipped_expression)
      condition_ignored = condition_stub.create!(:modifier => 'allow', :expression => expression)

      migrate

      expect(condition_changed.reload.expression).to eq(expected_expression)
      expect(condition_skipped.reload.expression).to eq(skipped_expression)
      expect(condition_ignored.reload.expression).to eq(expression)
    end
  end
end
