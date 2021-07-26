require "./symbol.cr"

module Kiwi
  # :nodoc:
  class Row
    @constant : Float64
    @cells : Hash(Symbol, Float64)

    property constant, cells

    def initialize
      initialize(0)
    end

    def initialize(@constant : Float64)
      @cells = {} of Symbol => Float64
    end

    def initialize(other : Row)
      @cells = other.cells.clone
      @constant = other.constant
    end

    def add(value : Float64) : Float64
      @constant += value
    end

    def insert(symbol : Symbol, coefficient : Float64)
      if cell_value = @cells[symbol]?
        coefficient += cell_value
      end

      if Util.near_zero(coefficient)
        @cells.delete symbol
      else
        @cells[symbol] = coefficient
      end
    end

    def insert(symbol : Symbol)
      insert(symbol, 1.0)
    end

    def insert(other : Row, coefficient : Float64)
      @constant += other.constant * coefficient
      
      other.cells.each do |symbol, other_value|
        coeff = other_value * coefficient
        # TODO: the below lines could be made more efficient
        value = 0.0
        if this_value = @cells[symbol]?
          value = this_value
        end
        temp = value + coeff
        if Util.near_zero(temp)
          @cells.delete symbol
        else
          @cells[symbol] = temp
        end
      end
    end

    def insert(other : Row)
      insert(other, 1.0)
    end

    def remove(symbol : Symbol)
      @cells.delete(symbol)
    end

    def reverse_sign
      @constant = -@constant

      @cells.transform_values! do |value|
        -value
      end
    end

    def solve_for(symbol : Symbol)
      coeff = -1.0 / @cells.delete(symbol).not_nil!
      @constant *= coeff

      @cells.transform_values! do |value|
        value * coeff
      end
    end

    def solve_for(lhs : Symbol, rhs : Symbol)
      insert(lhs, -1.0)
      solve_for(rhs)
    end

    def coefficient_for(symbol : Symbol) : Float64
      if result = @cells[symbol]?
        return result
      else
        return 0.0
      end
    end

    def substitute(symbol : Symbol, row : Row)
      if coefficient = @cells.delete symbol
        insert(row, coefficient)
      end
    end
  end
end
