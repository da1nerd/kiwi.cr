require "../variable_state.cr"

module Kiwi
  # This is a light wrapper around the actual `VariableState` that provides some helpful operators.
  class Variable
    @state : VariableState

    # :nodoc:
    getter state

    def initialize(name : String)
      @state = VariableState.new(name)
    end

    def initialize(value : Float64)
      @state = VariableState.new(value)
    end

    def name : String
      @state.name
    end

    def name=(name : String)
      @state.name = name
    end

    def value
      @state.value
    end

    def *(coefficient : Number) : Term
      Term.new(@state, coefficient)
    end

    {% for op in ["+", "-"] %}
      def {{op.id}}(constant : Number) : Expression
        Term.new(@state) {{op.id}} constant
      end

      def {{op.id}}(other : Variable) : Expression
        Term.new(@state) {{op.id}} other
      end

      def {{op.id}}(term : Term) : Expression
        Term.new(@state) {{op.id}} term
      end

      def {{op.id}}(expression : Expression) : Expression
        Term.new(@state) {{op.id}} expression
      end
    {% end %}

    {% for op in ["<=", ">=", "=="] %}
      def {{op.id}}(constant : Number) : Constraint
        Term.new(@state) {{op.id}} constant
      end

      def {{op.id}}(other : Variable) : Constraint
        Term.new(@state) {{op.id}} other
      end

      def {{op.id}}(term : Term) : Constraint
        Term.new(@state) {{op.id}} term
      end

      def {{op.id}}(expression : Expression) : Constraint
        Term.new(@state) {{op.id}} expression
      end
    {% end %}
  end
end
