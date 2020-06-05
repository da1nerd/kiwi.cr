module Kiwi::Strength
  extend self

  REQUIRED = create(1_000.0, 1_000.0, 1_000.0)
  STRONG   = create(1.0, 0.0, 0.0)
  MEDIUM   = create(0.0, 1.0, 0.0)
  WEAK     = create(0.0, 0.0, 1.0)

  def create(a : Float64, b : Float64, c : Float64, w : Float64) : Float64
    result = 0.0
    result += Math.max(0.0, Math.min(1_000.0, a * w)) * 1_000_000.0
    result += Math.max(0.0, Math.min(1_000.0, b * w)) * 1_000.0
    result += Math.max(0.0, Math.min(1_000.0, c * w))
    return result
  end

  def create(a : Float64, b : Float64, c : Float64) : Float64
    create(a, b, c, 1.0)
  end

  def clip(value : Float64) : Float64
    Math.max(0.0, Math.min(REQUIRED, value))
  end
end
