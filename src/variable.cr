require "./term.cr"
require "./expression.cr"
require "./constraint.cr"

module Kiwi
  class Variable
    @name : String
    @value : Float64

    property value : Float64
    getter name

    def initialize(@name : String)
      @value = 0.0
    end

    def initialize(@value : Float64)
      @name = ""
    end

    def *(coefficient : Number) : Term
      Term.new(self, coefficient)
    end

    def +(constant : Number) : Expression
      Term.new(self) + constant
    end

    def ==(constant : Number) : Constraint
      Term.new(self) == constant
    end

    def ==(expression : Expression) : Constraint
      expression == self
    end

    # TODO: this breaks everything because we use variables in a hash.
    #  and the hash needs `==`
    # def ==(other : Variable) : Constraint
    #   raise Exception.new("what are you doing")
    #   Term.new(self) == other
    # end

    def to_s(io)
      io << "name: " << @name << " value: " << @value
    end
  end
end
