require "./expression.cr"
require "./dsl/variable.cr"
require "./term.cr"
require "./constraint.cr"
require "./relational_operator.cr"

module Kiwi
  module Symbolics
    extend self

    # TODO: we can't support this using regular operators.
    def greater_than_or_equal_to(constant : Float64, variable : Variable)
      greater_than_or_equal_to(constant, Term.new(variable.state))
    end

    # TODO: we can't support this using regular operators
    def greater_than_or_equal_to(constant : Float64, term : Term)
      Expression.new(constant) >= term
    end

    def less_than_or_equal_to(variable : Variable, expression : Expression)
      less_than_or_equal_to(Term.new(variable.state), expression)
    end

    def less_than_or_equal_to(term : Term, expression : Expression)
      less_than_or_equal_to(Expression.new(term), expression)
    end

    def less_than_or_equal_to(first : Variable, second : Variable)
      less_than_or_equal_to(Term.new(first.state), second)
    end

    def less_than_or_equal_to(variable : Variable, constant : Float64)
      less_than_or_equal_to(Term.new(variable.state), constant)
    end

    def less_than_or_equal_to(term : Term, constant : Float64)
      less_than_or_equal_to(Expression.new(term), constant)
    end

    def less_than_or_equal_to(expression : Expression, constant : Float64)
      less_than_or_equal_to(expression, Expression.new(constant))
    end

    def less_than_or_equal_to(term : Term, variable : Variable)
      less_than_or_equal_to(Expression.new(term), variable)
    end

    def less_than_or_equal_to(expression : Expression, variable : Variable)
      less_than_or_equal_to(expression, Term.new(variable.state))
    end

    def less_than_or_equal_to(expression : Expression, term : Term)
      less_than_or_equal_to(expression, Expression.new(term))
    end

    def less_than_or_equal_to(constant : Float64, variable : Variable)
      less_than_or_equal_to(constant, Term.new(variable.state))
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
  end
end
