require "./symbol.cr"

module Kiwi
    class Solver
        private class Tag
            @marker : Symbol
            @other : Symbol

            def initialize
                @marker = Symbol.new
                @other = Symbol.new
            end
        end
    end
end