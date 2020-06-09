require "./spec_helper"

describe Kiwi do
  it "equality with lhs addition" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    solver.add_constraint(x + 2 == 20)
    solver.update_variables
    x.value.should be_close(18, EPSILON)
  end

  it "equality with addition on both sides" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(x == 20)
    solver.add_constraint(x + 2 == y + 10)
    solver.update_variables
    y.value.should be_close(12, EPSILON)
    x.value.should be_close(20, EPSILON)
  end

  it "simple 1" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    solver.add_constraint(x == y)
    solver.update_variables
    x.value.should be_close(y.value, EPSILON)
  end

  it "casso 1" do
    solver = Kiwi::Solver.new
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")

    solver.add_constraint(x <= y)
    solver.add_constraint(y == x + 3)
    tmpx = x == 10
    tmpx.strength = Kiwi::Strength::WEAK
    solver.add_constraint(tmpx)
    tmpy = y == 10
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

    tmpx = x <= 100
    tmpx.strength = Kiwi::Strength::WEAK
    solver.add_constraint(tmpx)
    solver.update_variables
    x.value.should be_close(100, EPSILON)

    c10 = x <= 10
    c20 = x <= 20
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

    c10again = x <= 10
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

    solver.add_constraint((x == 100).strength = Kiwi::Strength::WEAK)
    solver.add_constraint((y == 120).strength = Kiwi::Strength::STRONG)

    c10 = x <= 10
    c20 = x <= 20

    solver.add_constraint(c10)
    solver.add_constraint(c20)
    solver.update_variables

    x.value.should be_close(10, EPSILON)
    y.value.should be_close(120, EPSILON)

    solver.remove_constraint(c10)
    solver.update_variables

    x.value.should be_close(20, EPSILON)
    y.value.should be_close(120, EPSILON)

    cxy = x * 2 == y
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

  it "inconsistent 1" do
    x = Kiwi::Variable.new("x")
    solver = Kiwi::Solver.new

    solver.add_constraint(x == 10.0)

    expect_raises(Kiwi::UnsatisfiableConstraintException) do
      solver.add_constraint(x == 5.0)
      solver.update_variables
    end
  end

  it "inconsistent 2" do
    x = Kiwi::Variable.new("x")
    solver = Kiwi::Solver.new

    solver.add_constraint(x >= 10.0)

    expect_raises(Kiwi::UnsatisfiableConstraintException) do
      solver.add_constraint(x <= 5.0)
      solver.update_variables
    end
  end

  it "inconsistent 3" do
    w = Kiwi::Variable.new("w")
    x = Kiwi::Variable.new("x")
    y = Kiwi::Variable.new("y")
    z = Kiwi::Variable.new("z")
    solver = Kiwi::Solver.new

    solver.add_constraint(w >= 10.0)
    solver.add_constraint(x >= w)
    solver.add_constraint(y >= x)
    solver.add_constraint(z >= y)
    solver.add_constraint(z >= 8.0)

    expect_raises(Kiwi::UnsatisfiableConstraintException) do
      solver.add_constraint(z <= 4)
      solver.update_variables
    end
  end
end
