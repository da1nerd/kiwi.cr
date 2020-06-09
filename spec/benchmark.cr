require "../src/kiwi"
require "benchmark"

Benchmark.ips do |x|
  solver = Kiwi::Solver.new
  vars = [] of Kiwi::Variable
  vars << Kiwi::Variable.new("var0")
  solver.add_constraint(vars[0] == 100)
  x.report("add 3000 constraints") do
    1.upto(3000) do |i|
      vars << Kiwi::Variable.new("var#{i}")
      solver.add_constraint(vars[i] == 100 + vars[i - 1])
    end
  end
end
