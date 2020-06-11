require "./spec_helper"

# Generates tests for all operators with the input expression on the rhs and lhs
macro test_operators(expr)
    {% begin %}
        {% operations = [:>=, :<=, :==, :-, :+, :*] of ::Symbol %}
        {% for op in operations %}
            it "1 {{op.id}} rhs" do
                x = {{expr}}
                1f64 + x
            end
            it "lhs {{op.id}} 1" do
                x = {{expr}}
                x + 1f64
            end
        {% end %}
    {% end %}
end

# This simply tries to build some constraint expressions without throwing exceptions.
describe Kiwi do
  describe "number and variable operations" do
    test_operators Kiwi::Variable.new("x")
  end

  describe "number and term operations" do
    test_operators (Kiwi::Variable.new("x") * 1).as(Kiwi::Term)
  end

  describe "number and expression operations" do
    test_operators (Kiwi::Variable.new("x") + 1).as(Kiwi::Expression)
  end
end
