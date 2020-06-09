require "./term.cr"
require "./expression.cr"

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

    def *(coefficient : Float64) : Term
      Term.new(self, coefficient)
    end

    def +(constant : Float64) : Expression
      Term.new(self) + constant
    end

    def to_s(io)
      io << "name: " << @name << " value: " << @value
    end
  end
end
