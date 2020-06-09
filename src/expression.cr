require "./term.cr"
require "./relational_operator.cr"
require "./constraint.cr"
require "./variable_state.cr"

module Kiwi
  struct Expression
    @terms : Array(Term)
    @constant : Float64

    property constant, terms

    def initialize
      initialize(0.0)
    end

    def initialize(term : Term)
      initialize(term, 0.0)
    end

    def initialize(constant : Number)
      @constant = constant.to_f64
      @terms = [] of Term
    end

    def initialize(terms : Array(Term))
      initialize(terms, 0.0)
    end

    def initialize(term : Term, constant : Number)
      @constant = constant.to_f64
      @terms = [] of Term
      @terms << term
    end

    def initialize(@terms : Array(Term), constant : Number)
      @constant = constant.to_f64
    end

    def value : Float64
      result = @constant
      terms.each do |term|
        result += term.value
      end
      return result
    end

    def is_constant : Bool
      @terms.size == 0
    end

    # Adds the *other* `Expression` to this one and returns a new expression.
    def +(other : Expression) : Expression
      terms = [] of Term
      @terms.each { |t| terms << t }
      other.terms.each { |t| terms << t }
      Expression.new(terms, @constant + other.constant)
    end

    # Multiplies this expression with a *coefficient* and returns a new `Expression`.
    def *(coefficient : Number) : Expression
      terms = [] of Term

      @terms.each do |term|
        terms << term * coefficient
      end
      Expression.new(terms, @constant * coefficient)
    end

    # Subtracts the *other* `Expression` from this one and returns a new `Expression`
    def -(other : Expression) : Expression
      self + (other * -1)
    end

    def ==(other : Expression) : Constraint
      Constraint.new(self - other, RelationalOperator::OP_EQ)
    end

    def ==(term : Term) : Constraint
      self == Expression.new(term)
    end

    def ==(variable : Variable) : Constraint
      self == Term.new(variable.state)
    end

    def ==(constant : Number) : Constraint
      self == Expression.new(constant)
    end

    def >=(other : Expression) : Constraint
      Constraint.new(self - other, RelationalOperator::OP_GE)
    end

    def >=(constant : Number) : Constraint
      self >= Expression.new(constant)
    end

    def >=(term : Term) : Constraint
      self >= Expression.new(term)
    end

    def >=(variable : Variable) : Constraint
      self >= Term.new(variable.state)
    end

    def <=(other : Expression) : Constraint
      Constraint.new(self - other, RelationalOperator::OP_LE)
    end

    def <=(term : Term) : Constraint
      self <= Expression.new(term)
    end

    def <=(variable : Variable) : Constraint
      self <= Term.new(variable.state)
    end

    def <=(constant : Number) : Constraint
      self <= Expression.new(constant)
    end

    def to_s(io)
      io << "isConstant: " << is_constant << " constant: " << constant
      if !is_constant
        io << " terms: ["
        @terms.each do |term|
          io << "(" << term << ")"
        end
        io << "] "
      end
      io
    end
  end
end
