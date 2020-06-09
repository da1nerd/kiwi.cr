require "./variable_state.cr"
require "./dsl/variable.cr"
require "./expression.cr"
require "./constraint.cr"

module Kiwi
  struct Term
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

    def ==(constant : Number) : Constraint
      Expression.new(self) == constant
    end

    def ==(variable : Variable) : Constraint
      Expression.new(self) == variable
    end

    def >=(variable : Variable) : Constraint
      Expression.new(self) >= variable
    end

    def >=(expression : Expression) : Constraint
      Expression.new(self) >= expression
    end

    def >=(constant : Number) : Constraint
      Expression.new(self) >= constant
    end

    def <=(variable : Variable) : Constraint
      Expression.new(self) <= variable
    end

    def <=(constant : Number) : Constraint
      Expression.new(self) <= constant
    end

    def <=(expression : Expression) : Constraint
      Expression.new(self) <= expression
    end

    def to_s(io)
      io << "variable: (" << @variable << ") coefficient: " << @coefficient
    end
  end
end
