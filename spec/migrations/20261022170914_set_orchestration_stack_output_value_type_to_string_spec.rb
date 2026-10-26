require_migration

describe SetOrchestrationStackOutputValueTypeToString do
  let(:orchestration_stack_output_stub) { migration_stub(:OrchestrationStackOutput) }

  migration_context :up do
    it "sets value_type to string on existing outputs without a value_type" do
      missing_type = orchestration_stack_output_stub.create!(:key => "a", :value => "1")
      number_type  = orchestration_stack_output_stub.create!(:key => "b", :value => "2", :value_type => "number")

      migrate

      expect(missing_type.reload.value_type).to eq("string")
      expect(number_type.reload.value_type).to  eq("number")
    end
  end

  migration_context :down do
    it "clears value_type" do
      orchestration_stack_output_stub.create!(:key => "a", :value => "1", :value_type => "string")

      migrate

      expect(orchestration_stack_output_stub.pluck(:value_type)).to all(be_nil)
    end
  end
end
