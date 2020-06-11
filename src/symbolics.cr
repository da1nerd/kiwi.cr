require "./expression.cr"
require "./dsl/variable.cr"
require "./term.cr"
require "./constraint.cr"
require "./relational_operator.cr"

# :nodoc:
struct Number
  # TODO: use a macro to generate all of these

  def >=(variable : Kiwi::Variable)
    self >= Kiwi::Term.new(variable.state)
  end

  def >=(term : Kiwi::Term)
    Kiwi::Expression.new(self) >= term
  end

  def >=(expression : Kiwi::Expression)
    Kiwi::Expression.new(self) >= expression
  end

  def <=(variable : Kiwi::Variable)
    self <= Kiwi::Term.new(variable.state)
  end

  def <=(term : Kiwi::Term)
    self <= Kiwi::Expression.new(term)
  end

  def <=(expression : Kiwi::Expression)
    Kiwi::Expression.new(self) <= expression
  end

  def ==(variable : Kiwi::Variable)
    self == Kiwi::Term.new(variable.state)
  end

  def ==(term : Kiwi::Term)
    self == Kiwi::Expression.new(term)
  end

  def ==(expression : Kiwi::Expression)
    Kiwi::Expression.new(self) == expression
  end

  def +(variable : Kiwi::Variable)
    self + Kiwi::Term.new(variable.state)
  end

  def +(term : Kiwi::Term)
    self + Kiwi::Expression.new(term)
  end

  def +(expression : Kiwi::Expression)
    Kiwi::Expression.new(self) + expression
  end

  def -(variable : Kiwi::Variable)
    self - Kiwi::Term.new(variable.state)
  end

  def -(term : Kiwi::Term)
    self - Kiwi::Expression.new(term)
  end

  def -(expression : Kiwi::Expression)
    Kiwi::Expression.new(self) - expression
  end

  def *(variable : Kiwi::Variable)
    variable * self
  end

  def *(term : Kiwi::Term)
    term * self
  end

  def *(expression : Kiwi::Expression)
    expression * self
  end
end
