require "../spec_helper"

describe Kiwi do
  it "checks that a variable is less than or equal to a value" do
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver = Kiwi::Solver.new
    solver.add_constraint(y == 100)
    solver.add_constraint(Kiwi::Symbolics.less_than_or_equal_to(x, y))
    solver.update_variables
    (100 <= x.value).should be_truthy
    solver.add_constraint(x == 90)
    solver.update_variables
    x.value.should be_close(90, EPSILON)
  end

  it "is unable to satisfy a less than or equal to constraint" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(y == 100)
    solver.add_constraint(Kiwi::Symbolics.less_than_or_equal_to(x, y))
    solver.update_variables
    (x.value <= 100).should be_truthy

    expect_raises(Kiwi::UnsatisfiableConstraintException) do
      solver.add_constraint(x == 110)
      solver.update_variables
    end
  end

  it "check that a variable is greater than or equal to a value" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(y == 100)
    solver.add_constraint(x >= y)
    solver.update_variables
    (x.value >= 100).should be_truthy
    solver.add_constraint(x == 110)
    solver.update_variables
    x.value.should be_close(110, EPSILON)
  end

  it "is unable to satisfy a greater than or equal to constraint" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(y == 100)
    solver.add_constraint(x >= y)
    solver.update_variables
    (x.value >= 100).should be_truthy
    expect_raises(Kiwi::UnsatisfiableConstraintException) do
      solver.add_constraint(x == 90)
      solver.update_variables
    end
  end
end
