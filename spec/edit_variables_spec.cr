require "./spec_helper"

describe Kiwi do
  it "suggests a new variable value" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(x == y * 2)
    solver.add_edit_variable(x, Kiwi::Strength::STRONG)

    solver.suggest_value(x, 4)
    solver.update_variables
    x.value.should eq(4)
    y.value.should eq(2)

    solver.remove_edit_variable(x)
    solver.add_edit_variable(x, Kiwi::Strength::STRONG)
    solver.suggest_value(x, 8)
    solver.update_variables
    x.value.should eq(8)
    y.value.should eq(4)
  end
end