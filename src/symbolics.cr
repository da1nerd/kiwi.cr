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
      Constraint.new(subtract(first, second), RelationalOperator::OP_LE)
    end

    def subtract(first : Expression, second : Expression) : Expression
      add(first, negate(second))
    end

    def negate(expression : Expression) : Expression
      multiply(expression, -1.0)
    end

    def multiply(expression : Expression, coefficient : Float64) : Expression
      terms = [] of Term

      expression.terms.each do |term|
        terms << multiply(term, coefficient)
      end
      Expression.new(terms, expression.constant * coefficient)
    end

    def multiply(term : Term, coefficient : Float64) : Term
      Term.new(term.variable, term.coefficient * coefficient)
    end

    def add(first : Expression, second : Expression) : Expression
      terms = [] of Term
      first.terms.each { |t| terms << t }
      second.terms.each { |t| terms << t }
      Expression.new(terms, first.constant + second.constant)
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
      Constraint.new(subtract(first, second), RelationalOperator::OP_EQ)
    end
  end
end
