require "./tag.cr"
require "./constraint.cr"

module Kiwi
    class Solver
        private class EditInfo
            @tag : Tag
            @constraint : Constraint
            @constant : Float64

            def initialize(@constraint : Constraint, @tag : Tag, @constant : Float64)
            end
        end
    end
end