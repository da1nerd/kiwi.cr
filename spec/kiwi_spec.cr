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

  it "add delete 1" do
    x = Kiwi::Variable.new("x")
    solver = Kiwi::Solver.new

    tmpx = Kiwi::Symbolics.less_than_or_equal_to(x, 100)
    tmpx.strength = Kiwi::Strength::WEAK
    solver.add_constraint(tmpx)
    solver.update_variables
    x.value.should be_close(100, EPSILON)

    c10 = Kiwi::Symbolics.less_than_or_equal_to(x, 10)
    c20 = Kiwi::Symbolics.less_than_or_equal_to(x, 20)
    solver.add_constraint(c10)
    solver.add_constraint(c20)
    solver.update_variables
    x.value.should be_close(10, EPSILON)

    solver.remove_constraint(c10)
    solver.update_variables
    x.value.should be_close(20, EPSILON)

    solver.remove_constraint(c20)
    solver.update_variables
    x.value.should be_close(100, EPSILON)

    c10again = Kiwi::Symbolics.less_than_or_equal_to(x, 10)
    solver.add_constraint(c10again)
    solver.add_constraint(c10)
    solver.update_variables
    x.value.should be_close(10, EPSILON)

    solver.remove_constraint(c10)
    solver.update_variables
    x.value.should be_close(10, EPSILON)

    solver.remove_constraint(c10again)
    solver.update_variables
    x.value.should be_close(100, EPSILON)
  end

  it "add delete 2" do
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver = Kiwi::Solver.new

    solver.add_constraint(Kiwi::Symbolics.equals(x, 100).strength = Kiwi::Strength::WEAK)
    solver.add_constraint(Kiwi::Symbolics.equals(y, 120).strength = Kiwi::Strength::STRONG)

    c10 = Kiwi::Symbolics.less_than_or_equal_to(x, 10)
    c20 = Kiwi::Symbolics.less_than_or_equal_to(x, 20)

    solver.add_constraint(c10)
    solver.add_constraint(c20)
    solver.update_variables

    x.value.should be_close(10, EPSILON)
    y.value.should be_close(120, EPSILON)

    solver.remove_constraint(c10)
    solver.update_variables

    x.value.should be_close(20, EPSILON)
    y.value.should be_close(120, EPSILON)

    cxy = Kiwi::Symbolics.equals(Kiwi::Symbolics.multiply(x, 2), y)
    solver.add_constraint(cxy)
    solver.update_variables

    x.value.should be_close(20, EPSILON)
    y.value.should be_close(40, EPSILON)

    solver.remove_constraint(c20)
    solver.update_variables

    x.value.should be_close(60, EPSILON)
    y.value.should be_close(120, EPSILON)

    solver.remove_constraint(cxy)
    solver.update_variables

    x.value.should be_close(100, EPSILON)
    y.value.should be_close(120, EPSILON)
  end
end
