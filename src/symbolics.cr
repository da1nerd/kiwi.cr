require "./expression.cr"
require "./variable.cr"
require "./term.cr"
require "./constraint.cr"
require "./relational_operator.cr"

module Kiwi
  module Symbolics
    extend self

    def greater_than_or_equal_to(variable : Variable, constant : Float64)
      greater_than_or_equal_to(Term.new(variable), constant)
    end

    def greater_than_or_equal_to(term : Term, constant : Float64)
      greater_than_or_equal_to(Expression.new(term), constant)
    end

    def greater_than_or_equal_to(expression : Expression, constant : Float64)
      greater_than_or_equal_to(expression, Expression.new(constant))
    end

    def greater_than_or_equal_to(first : Expression, second : Expression) : Constraint
      Constraint.new(first - second, RelationalOperator::OP_GE)
    end

    def greater_than_or_equal_to(constant : Float64, variable : Variable)
      greater_than_or_equal_to(constant, Term.new(variable))
    end

    def greater_than_or_equal_to(constant : Float64, term : Term)
      greater_than_or_equal_to(Expression.new(constant), term)
    end

    def greater_than_or_equal_to(first : Variable, second : Variable)
      greater_than_or_equal_to(Term.new(first), second)
    end

    def greater_than_or_equal_to(variable : Variable, expression : Expression)
      greater_than_or_equal_to(Term.new(variable), expression)
    end

    def greater_than_or_equal_to(term : Term, expression : Expression)
      greater_than_or_equal_to(Expression.new(term), expression)
    end

    def greater_than_or_equal_to(term : Term, variable : Variable)
      greater_than_or_equal_to(Expression.new(term), variable)
    end

    def greater_than_or_equal_to(expression : Expression, variable : Variable)
      greater_than_or_equal_to(expression, Term.new(variable))
    end

    def greater_than_or_equal_to(expression : Expression, term : Term)
      greater_than_or_equal_to(expression, Expression.new(term))
    end

    def less_than_or_equal_to(variable : Variable, expression : Expression)
      less_than_or_equal_to(Term.new(variable), expression)
    end

    def less_than_or_equal_to(term : Term, expression : Expression)
      less_than_or_equal_to(Expression.new(term), expression)
    end

    def less_than_or_equal_to(first : Variable, second : Variable)
      less_than_or_equal_to(Term.new(first), second)
    end

    def less_than_or_equal_to(variable : Variable, constant : Float64)
      less_than_or_equal_to(Term.new(variable), constant)
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
      less_than_or_equal_to(expression, Term.new(variable))
    end

    def less_than_or_equal_to(expression : Expression, term : Term)
      less_than_or_equal_to(expression, Expression.new(term))
    end

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

    def equals(first : Variable, second : Variable)
      equals(Term.new(first), second)
    end

    def equals(term : Term, variable : Variable)
      equals(Expression.new(term), variable)
    end

    def equals(expression : Expression, variable : Variable)
      equals(expression, Term.new(variable))
    end

    def equals(expression : Expression, term : Term)
      equals(expression, Expression.new(term))
    end

    def equals(variable : Variable, expression : Expression)
      equals(expression, variable)
    end

    def equals(first : Expression, second : Expression) : Constraint
      Constraint.new(first - second, RelationalOperator::OP_EQ)
    end

    def add(variable : Variable, constant : Float64)
      add(Term.new(variable), constant)
    end

    def add(term : Term, constant : Float64)
      Expression.new(term, constant)
    end

    def multiply(variable : Variable, coefficient : Float64)
      Term.new(variable, coefficient)
    end
  end
end
