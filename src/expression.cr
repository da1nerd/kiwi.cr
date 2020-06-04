require "./term.cr"

module Kiwi
    class Expression
        @terms : Array(Term)
        @constant : Float64

        property constant, terms

        def initialize
            initialize(0.0)
        end

        def initialize(term : Term)
            initialize(term, 0.0)
        end

        def initialize(@constant : Float64)
            @terms = [] of Term
        end

        def initialize(terms : Term[])
            initialize(terms, 0.0)
        end

        def initialize(term : Term, @constant : Float64)
            @terms = [] of Term
            @terms << term
        end

        def initialize(@terms : Term[], @constant : Float64)
        end

        def value : Float64
            result = @constant
            terms.each do |term|
                result += term.value
            end
            return result
        end

        def is_constant : Bool
            @terms.size == 0
        end

        def to_s(io)
            io << "isConstant: " << is_constant << " constant: " << constant
            if !is_constant
                io << " terms: ["
                    @terms.each do |term|
                        io << "(" << term << ")"
                    end
                io << "] "
            end
            io
        end
    end
end