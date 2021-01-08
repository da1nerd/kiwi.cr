require "./solver.cr"
require "./variable_state.cr"
require "./symbolics.cr"
require "./dsl"

# Kiwi is a constraint solving algorith specifically designed for
# solving GUI layout constraints.
#
# Usage is very simple, you just need to create an instance of the `Solver`
# and a few `Variable`s.
# The actual constraints are written out like you would any mathematical equation.
#
# Constraints support these opperators: `>=`, `<=`, `==`, `*`, `+`, and `-`.
#
# The `Solver` will not allow you to add a constraint that cannot be solved, and will raise an exception.
#
# ##Example
#
# ```
# solver = Kiwi::Solver.new
# x = Kiwi::Variable.new("x")
# y = Kiwi::Variable.new("y")
# solver.add_constraint(x == 20)
# solver.add_constraint(x + 2 == y + 10)
# solver.update_variables
# y.value # => 12
# x.value # => 20
# ```
module Kiwi
  VERSION = "0.3.0"
end
