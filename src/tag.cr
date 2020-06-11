require "./symbol.cr"

module Kiwi
  class Solver
    # :nodoc:
    private class Tag
      @marker : Symbol
      @other : Symbol

      property marker, other

      def initialize
        @marker = Symbol.new
        @other = Symbol.new
      end
    end
  end
end
