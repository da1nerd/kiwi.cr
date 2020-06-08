require "./expression.cr"
require "./variable.cr"
require "./term.cr"
require "./constraint.cr"
require "./relational_operator.cr"

module Kiwi
  module Symbolics
    extend self

    def less_than_or_equal_to(constant : Float64, variable : Variable)
      less_than_or_equal_to(constant, Term.new(variable))
    end

    def less_than_or_equal_to(constant : Float64, term : Term)
      less_than_or_equal_to(constant, Expression.new(term))
    end

    def less_than_or_equal_to(constant : Float64, expression : Expression)
      less_than_or_equal_to(Expression.new(constant), expression)
    end

    def less_than_or_equal_to(first : Expression, second : Expression) : Constraint
      Constraint.new(first - second, RelationalOperator::OP_LE)
    end

    def equals(variable : Variable, constant : Float64)
      equals(Term.new(variable), constant)
    end

    def equals(term : Term, constant : Float64)
      equals(Expression.new(term), constant)
    end

    def equals(expression : Expression, constant : Float64)
      equals(expression, Expression.new(constant))
    end

    def equals(first : Expression, second : Expression) : Constraint
      Constraint.new(first - second, RelationalOperator::OP_EQ)
    end
  end
end
