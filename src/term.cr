require "./variable_state.cr"
require "./dsl/variable.cr"
require "./expression.cr"
require "./constraint.cr"

module Kiwi
  # :nodoc:
  class Term
    @variable : VariableState
    @coefficient : Float64

    property variable, coefficient

    def initialize(@variable : VariableState, coefficient : Number)
      @coefficient = coefficient.to_f64
    end

    def initialize(variable : VariableState)
      initialize(variable, 1.0)
    end

    def value : Float64
      @coefficient * @variable.value
    end

    # Multiplies this term with a *coefficient* and returns a new `Term`
    def *(coefficient : Number) : Term
      Term.new(@variable, @coefficient * coefficient)
    end

    def +(constant : Number) : Expression
      Expression.new(self, constant)
    end

    def +(term : Term) : Expression
      Expression.new(self) + term
    end

    def +(variable : Variable) : Expression
      Expression.new(self) + variable
    end

    def -(constant : Number) : Expression
      Expression.new(self, -constant)
    end

    def -(variable : Variable) : Expression
      Expression.new(self) - variable
    end

    def -(term : Term) : Expression
      Expression.new(self) - term
    end

    {% for op in ["<=", ">=", "=="] %}
      def {{op.id}}(variable : Variable) : Constraint
        Expression.new(self) {{op.id}} variable
      end

      def {{op.id}}(constant : Number) : Constraint
        Expression.new(self) {{op.id}} constant
      end

      def {{op.id}}(other : Term) : Constraint
        Expression.new(self) {{op.id}} other
      end

      def {{op.id}}(expression : Expression) : Constraint
        Expression.new(self) {{op.id}} expression
      end
    {% end %}

    def to_s(io)
      io << @variable << "~coeff:" << @coefficient
    end
  end
end
