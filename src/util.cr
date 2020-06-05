module Kiwi
  module Util
    extend self

    EPS = 1.0e-8f64

    def near_zero(value : Float64) : Bool
      value < 0 ? -value < EPS : value < EPS
    end
  end
end
