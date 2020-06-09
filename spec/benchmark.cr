require "../src/kiwi"
require "benchmark"

def constraint_runner(num)
  solver = Kiwi::Solver.new
  vars = [] of Kiwi::Variable
  vars << Kiwi::Variable.new("var0")
  solver.add_constraint(vars[0] == 100)
  1.upto(num) do |i|
    vars << Kiwi::Variable.new("var#{i}")
    solver.add_constraint(vars[i] == 100 + vars[i - 1])
  end
end

Benchmark.ips do |x|
  x.report("add 30 constraints") do
    constraint_runner(30)
  end

  x.report("add 60 constraints") do
    constraint_runner(60)
  end

  x.report("add 300 constraints") do
    constraint_runner(300)
  end

  x.report("add 3000 constraints") do
    constraint_runner(3000)
  end
end
