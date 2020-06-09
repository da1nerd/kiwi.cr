require "./expression.cr"
require "./dsl/variable.cr"
require "./term.cr"
require "./constraint.cr"
require "./relational_operator.cr"

module Kiwi
  # TODO: we can't support left-hand-side number operations in the overloaded operators.
  module Symbolics
    extend self

    def greater_than_or_equal_to(constant : Float64, variable : Variable)
      greater_than_or_equal_to(constant, Term.new(variable.state))
    end

    def greater_than_or_equal_to(constant : Float64, term : Term)
      Expression.new(constant) >= term
    end

    def less_than_or_equal_to(constant : Float64, variable : Variable)
      less_than_or_equal_to(constant, Term.new(variable.state))
    end

    def less_than_or_equal_to(constant : Float64, term : Term)
      less_than_or_equal_to(constant, Expression.new(term))
    end

    def less_than_or_equal_to(constant : Float64, expression : Expression)
      Expression.new(constant) <= expression
    end
  end
end
