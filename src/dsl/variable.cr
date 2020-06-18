require "../variable_state.cr"

module Kiwi
  # This is a light wrapper around the actual `VariableState` that provides some helpful operators.
  struct Variable
    @state : VariableState

    # :nodoc:
    getter state

    def initialize(name : String)
      @state = VariableState.new(name)
    end

    def initialize(value : Float64)
      @state = VariableState.new(value)
    end

    def value
      @state.value
    end

    def *(coefficient : Number) : Term
      Term.new(@state, coefficient)
    end

    def +(constant : Number) : Expression
      Term.new(@state) + constant
    end

    def -(constant : Number) : Expression
      Term.new(@state) - constant
    end

    def - (variable : Variable) : Expression
      Term.new(@state) - variable
    end

    def +(term : Term) : Expression
      Term.new(@state) + term
    end

    def ==(constant : Number) : Constraint
      Term.new(@state) == constant
    end

    def ==(other : Variable) : Constraint
      Term.new(@state) == other
    end

    def ==(term : Term) : Constraint
      Term.new(@state) == term
    end

    def ==(expression : Expression) : Constraint
      expression == self
    end

    def >=(constant : Number) : Constraint
      Term.new(@state) >= constant
    end

    def >=(other : Variable) : Constraint
      Term.new(@state) >= other
    end

    def >=(expression : Expression) : Constraint
      Term.new(@state) >= expression
    end

    def <=(constant : Number) : Constraint
      Term.new(@state) <= constant
    end

    def <=(other : Variable) : Constraint
      Term.new(@state) <= other
    end

    def <=(expression : Expression) : Constraint
      Term.new(@state) <= expression
    end
  end
end
