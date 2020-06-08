require "./kiwi_exception.cr"
require "../constraint.cr"

module Kiwi
  class InternalSolverError < Exception
  end

  class DuplicateConstraintException < KiwiException
    @constraint : Constraint

    def initialize(@constraint : Constraint)
    end
  end

  class DuplicateEditVariableException < KiwiException
  end

  class InternalSolverError < Exception
  end

  class NonLinearExpressionException < KiwiException
  end

  class RequiredFailureException < KiwiException
  end

  class UnknownConstraintException < KiwiException
    @constraint : Constraint

    def initialize(@constraint : Constraint)
    end
  end

  class UnknownEditVariableException < Exception
  end

  class UnsatisfiableConstraintException < KiwiException
    @constraint : Constraint

    def initialize(@constraint : Constraint)
      super(constraint.to_s)
    end
  end
end
