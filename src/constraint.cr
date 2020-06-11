require "./expression.cr"
require "./relational_operator.cr"
require "./term.cr"
require "./variable_state.cr"
require "./strength.cr"

module Kiwi
  class Constraint
    @expression : Expression
    @strength : Float64
    @op : RelationalOperator

    # :nodoc:
    property expression, op
    getter strength

    # :nodoc:
    def initialize(expression : Expression, op : RelationalOperator)
      initialize(expression, op, Strength::REQUIRED)
    end

    # :nodoc:
    def initialize(other : Constraint, strength : Float64)
      initialize(other.expression, other.op, strength)
    end

    # :nodoc:
    def initialize(expression : Expression, @op : RelationalOperator, strength : Float64)
      @expression = reduce(expression)
      @strength = Strength.clip(strength)
    end

    def strength=(@strength : Float64)
      self
    end

    private def reduce(expression : Expression) : Expression
      vars = {} of VariableState => Float64
      expression.terms.each do |term|
        value = 0.0
        if vars.has_key? term.variable
          value = vars[term.variable]
        end
        value += term.coefficient
        vars[term.variable] = value
      end
      reduced_terms = [] of Term
      vars.each_key do |variable|
        reduced_terms << Term.new(variable, vars[variable])
      end
      Expression.new(reduced_terms, expression.constant)
    end

    def to_s(io)
      io << "expression: (" << @expression << ") strength: " << @strength << " operator: " << @op
    end
  end
end
