require "./spec_helper"

describe Kiwi do
  it "works" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    solver.add_constraint(Kiwi::Symbolics.equals(Kiwi::Symbolics.add(x, 2), 20))
    solver.update_variables
    x.value.should be_close(18, EPSILON)
  end

  it "simple 0" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(Kiwi::Symbolics.equals(x, 20))
    solver.add_constraint(Kiwi::Symbolics.equals(Kiwi::Symbolics.add(x, 2), Kiwi::Symbolics.add(y, 10)))
    solver.update_variables
    y.value.should be_close(12, EPSILON)
    x.value.should be_close(20, EPSILON)
  end

  it "simple 1" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(Kiwi::Symbolics.equals(x, y))
    solver.update_variables
    x.value.should be_close(y.value, EPSILON)
  end

  it "casso 1" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")

    solver.add_constraint(Kiwi::Symbolics.less_than_or_equal_to(x, y))
    solver.add_constraint(Kiwi::Symbolics.equals(y, Kiwi::Symbolics.add(x, 3)))
    tmpx = Kiwi::Symbolics.equals(x, 10)
    tmpx.strength = Kiwi::Strength::WEAK
    solver.add_constraint(tmpx)
    tmpy = Kiwi::Symbolics.equals(y, 10)
    tmpy.strength = Kiwi::Strength::WEAK
    solver.add_constraint(tmpy)
    solver.update_variables

    if (x.value - 10).abs < EPSILON
      x.value.should be_close(10, EPSILON)
      y.value.should be_close(13, EPSILON)
    else
      x.value.should be_close(7, EPSILON)
      y.value.should be_close(10, EPSILON)
    end
  end
end
