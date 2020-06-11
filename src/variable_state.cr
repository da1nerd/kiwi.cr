require "./term.cr"
require "./expression.cr"
require "./constraint.cr"

module Kiwi
  # :nodoc:
  class VariableState
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

    def to_s(io)
      io << "name: " << @name << " value: " << @value
    end
  end
end
