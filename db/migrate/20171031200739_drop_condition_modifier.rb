class DropConditionModifier < ActiveRecord::Migration[5.0]
  class Condition < ActiveRecord::Base
    def reverse_expression(migration)
      val = expression
      if val.include?("!ruby/object:MiqExpression")
        val.sub!(/MiqExpression/, 'Hash')
      else
        migration.say("#{self.class} Id: #{id} does not have an MiqExpression, skipping conversion")
        return
      end

      raw_hash = YAML.safe_load(val)
      raw_hash["exp"] = { "not" => raw_hash["exp"]}
      new_hash = YAML.dump(raw_hash).sub(/---/, "--- !ruby/object:MiqExpression")
      update_attributes(:expression => new_hash)
    end
  end

  def up
    say_with_time("Reverse the expression if :modifier = 'deny'") do
      Condition.where(:modifier => 'deny').find_each do |c|
        c.reverse_expression(self)
      end
    end
    remove_column :conditions, :modifier
  end

  def down
    add_column :conditions, :modifier, :string
  end
end
