require "./variable.cr"

module Kiwi
  class Term
    @variable : Variable
    @coefficient : Float64

    property variable, coefficient

    def initialize(@variable : Variable, @coefficient : Float64)
    end

    def initialize(variable : Variable)
      initialize(variable, 1.0)
    end

    def value : Float64
      @coefficient * @variable.value
    end

    # Multiplies this term with a *coefficient* and returns a new `Term`
    def *(coefficient : Float64) : Term
      Term.new(@variable, @coefficient * coefficient)
    end

    def to_s(io)
      io << "variable: (" << @variable << ") coefficient: " << @coefficient
    end
  end
end
