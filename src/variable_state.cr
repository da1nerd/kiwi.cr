require "./term.cr"
require "./expression.cr"
require "./constraint.cr"

module Kiwi
  # :nodoc:
  class VariableState
    @name : String
    @value : Float64

    property value : Float64
    property name

    def initialize
      initialize("unnamed")
    end

    def initialize(@name : String)
      @value = 0.0
    end

    def initialize(@value : Float64)
      @name = ""
    end

    def to_s(io)
      io << "var " << @name << " = " << @value
    end
  end
end
