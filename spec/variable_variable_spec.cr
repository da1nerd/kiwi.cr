require "./spec_helper"

EPSILON = 1.0e-8f64

describe Kiwi do
  it "checks that a variable is less than or equal to a value" do
    x = Kiwi::Variable.new("x")
    solver = Kiwi::Solver.new
    solver.add_constraint(Kiwi::Symbolics.less_than_or_equal_to(100, x))
    solver.update_variables
    (100 <= x.value).should be_truthy
    solver.add_constraint(Kiwi::Symbolics.equals(x, 110))
    solver.update_variables
    x.value.should be_close(110, EPSILON)
  end
end
