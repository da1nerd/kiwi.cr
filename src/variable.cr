module Kiwi
  class Variable
    @name : String
    @value : Float64

    property value
    getter name

    def initialize(@name : String)
      @value = 0.0
    end

    def initialize(@value)
      @name = ""
    end

    def to_s(io)
      io << "name: " << @name << " value: " << @value
    end
  end
end
