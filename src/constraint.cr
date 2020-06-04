require "./expression.cr"
require "./relational_operator.cr"
require "./term.cr"
require "./variable.cr"
require "./strength.cr"

module Kiwi
    class Constraint
        @expression : Expression
        @strength : Float64
        @op : RelationalOperator

        property expression, strength, op

        def initialize(expression : Expression, op : RelationalOperator)
            initialize(expression, op, Strength::REQUIRED)
        end


        def initialize(other : Constraint, strength : Float64)
            initialize(other.expression, other.op, strength)
        end

        def initialize(expression : Expression, @op : RelationalOperator, strength : Float64)
            @expression = reduce(expression)
            @strength = Strength.clip(strength)
        end

        private def self.reduce(expression : Expression) : Expression
            vars = {} of Variable => Float64
            expression.terms.each do |term|
                value = 0.0
                if vars.has_key term.variable
                    value = vars[term.variable]
                end
                value += term.coefficient
                vars[term.variable] = value
            end
            reduced_terms = [] of Term
            vars.each_key do |variable|
                reduced_terms << Term.new(variable, vars[variable])
            end
            Expression.new(reduced_terms, expression.constant)
        end

        def to_s(io)
            io << "expression: (" << @expression << ") strength: " << @strength << " operator: " << @op
        end
    end
end