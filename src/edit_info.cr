require "./tag.cr"
require "./constraint.cr"

module Kiwi
  class Solver
    # :nodoc:
    private class EditInfo
      @tag : Tag
      @constraint : Constraint
      @constant : Float64

      property constant
      getter tag, constraint

      def initialize(@constraint : Constraint, @tag : Tag, @constant : Float64)
      end
    end
  end
end
