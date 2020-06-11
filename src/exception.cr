require "./constraint.cr"

module Kiwi::KiwiException
  class InternalSolverError < Exception
  end

  class DuplicateConstraintException < Exception
    @constraint : Constraint

    def initialize(@constraint : Constraint)
    end
  end

  class DuplicateEditVariableStateException < Exception
  end

  class InternalSolverError < Exception
  end

  class NonLinearExpressionException < Exception
  end

  class RequiredFailureException < Exception
  end

  class UnknownConstraintException < Exception
    @constraint : Constraint

    def initialize(@constraint : Constraint)
    end
  end

  class UnknownEditVariableStateException < Exception
  end

  class UnsatisfiableConstraintException < Exception
    @constraint : Constraint

    def initialize(@constraint : Constraint)
      super(constraint.to_s)
    end
  end
end
