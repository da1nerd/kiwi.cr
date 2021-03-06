require "./tag.cr"
require "./edit_info.cr"
require "./constraint.cr"
require "./variable_state.cr"
require "./row.cr"
require "./symbol.cr"
require "./util.cr"
require "./exception"

module Kiwi
  include KiwiException

  class Solver
    @cns : Hash(Constraint, Tag)
    @rows : Hash(Symbol, Row)
    @vars : Hash(VariableState, Symbol)
    @edits : Hash(VariableState, EditInfo)
    @infeasible_rows : Array(Symbol)
    @objective : Row
    @artificial : Row | Nil

    def initialize
      @cns = {} of Constraint => Tag
      @rows = {} of Symbol => Row
      @vars = {} of VariableState => Symbol
      @edits = {} of VariableState => EditInfo
      @infeasible_rows = [] of Symbol
      @objective = Row.new
    end

    # Adds a constraint to the system.
    #
    # ##Example
    #
    # ```
    # solver = Kiwi::Solver.new
    # x = Kiwi::Variable.new("x")
    # solver.add_constraint(x + 2 == 4)
    # ```
    def add_constraint(constraint : Constraint)
      if @cns.has_key? constraint
        raise DuplicateConstraintException.new(constraint)
      end

      tag = Tag.new
      row = create_row(constraint, tag)
      subject = choose_subject(row, tag)

      if subject.type == Symbol::Type::INVALID && all_dummies(row)
        if !Util.near_zero(row.constant)
          raise UnsatisfiableConstraintException.new(constraint)
        else
          subject = tag.marker
        end
      end

      if subject.type == Symbol::Type::INVALID
        if !add_with_artificial_variable(row)
          raise UnsatisfiableConstraintException.new(constraint)
        end
      else
        row.solve_for(subject)
        substitute(subject, row)
        @rows[subject] = row
      end

      @cns[constraint] = tag
      optimize(@objective)
    end

    # Removes a constraint from the system
    #
    # ## Example
    #
    # ```
    # solver = Kiwi::Solver.new
    # x = Kiwi::Variable.new("x")
    # constraint = x + 2 == 4
    # solver.add_constraint(constraint)
    # solver.remove_constraint(constraint)
    # ```
    def remove_constraint(constraint : Constraint)
      if !@cns.has_key?(constraint)
        raise UnknownConstraintException.new(constraint)
      end

      tag = @cns[constraint]
      @cns.delete constraint
      remove_constraint_effects(constraint, tag)

      if @rows.has_key? tag.marker
        @rows.delete tag.marker
      else
        row = get_marker_leaving_row(tag.marker)
        leaving = get_row_symbol(row)

        @rows.delete leaving
        row.solve_for(leaving, tag.marker)
        substitute(tag.marker, row)
      end
      optimize(@objective)
    end

    private def remove_constraint_effects(constraint : Constraint, tag : Tag)
      if tag.marker.type == Symbol::Type::ERROR
        remove_marker_effects(tag.marker, constraint.strength)
      elsif tag.other.type == Symbol::Type::ERROR
        remove_marker_effects(tag.other, constraint.strength)
      end
    end

    private def remove_marker_effects(marker : Symbol, strength : Float64)
      if @rows.has_key? marker
        @objective.insert(@rows[marker], -strength)
      else
        @objective.insert(marker, -strength)
      end
    end

    private def get_marker_leaving_row(marker : Symbol) : Row
      r1 = Float64::MAX
      r2 = Float64::MAX

      first : Row? = nil
      second : Row? = nil
      third : Row? = nil

      @rows.each_key do |symbol|
        candidate_row = @rows[symbol]
        c = candidate_row.coefficient_for(marker)
        if c == 0
          next
        end
        if symbol.type == Symbol::Type::EXTERNAL
          third = candidate_row
        elsif c < 0
          r = -candidate_row.constant / c
          if r < r1
            r1 = r
            first = candidate_row
          end
        else
          r = candidate_row.constant / c
          if r < r2
            r2 = r
            second = candidate_row
          end
        end
      end

      if result = first
        return result
      end
      if result = second
        return result
      end
      if result = third
        return result
      end

      raise InternalSolverError.new("internal solver error")
    end

    # Checks if the constraint has already been added to the solver.
    #
    # ## Example
    #
    # ```
    # solver = Kiwi::Solver.new
    # x = Kiwi::Variable.new("x")
    # constraint = x + 2 == 4
    # solver.add_constraint(constraint)
    # solver.has_constraint(constraint) # => true
    # ```
    def has_constraint(constraint : Constraint) : Bool
      @cns.has_key?(constraint)
    end

    # TODO: What's this for?
    def add_edit_variable(variable : Variable, strength : Float64)
      if @edits.has_key? variable.state
        raise DuplicateEditVariableStateException.new
      end

      strength = Strength.clip(strength)

      if strength == Strength::REQUIRED
        raise RequiredFailureException.new
      end

      terms = [] of Term
      terms << Term.new(variable.state)
      constraint = Constraint.new(Expression.new(terms), RelationalOperator::OP_EQ, strength)

      begin
        add_constraint(constraint)
      rescue ex
        puts ex.message
      end

      @edits[variable.state] = EditInfo.new(constraint, @cns[constraint], 0)
    end

    # TODO: What's this for?
    def remove_edit_variable(variable : Variable)
      if !@edits.has_key?(variable.state)
        raise UnknownEditVariableStateException.new
      end

      begin
        remove_constraint(@edits[variable.state].constraint)
      rescue ex
        puts ex.message
      end

      @edits.delete variable.state
    end

    # TODO: What's this for?
    def has_edit_variable(variable : Variable) : Bool
      @edits.has_key? variable.state
    end

    # Suggests the value of a variable
    # This raises an exception if the variable has not been defined as an editable variable.
    def suggest_value(variable : Variable, value : Float64)
      if !@edits.has_key?(variable.state)
        raise UnknownEditVariableStateException.new
      end
      info = @edits[variable.state]
      delta = value - info.constant
      info.constant = value

      if @rows.has_key?(info.tag.marker)
        row = @rows[info.tag.marker]
        if row.add(-delta) < 0
          @infeasible_rows << info.tag.marker
        end
        dual_optimize
        return
      end

      if @rows.has_key?(info.tag.other)
        row = @rows[info.tag.other]
        if row.add(delta) < 0
          @infeasible_rows << info.tag.other
        end
        dual_optimize
        return
      end

      @rows.each_key do |symbol|
        current_row = @rows[symbol]
        coefficient = current_row.coefficient_for(info.tag.marker)
        if coefficient != 0 && current_row.add(delta * coefficient) < 0 && symbol.type != Symbol::Type::EXTERNAL
          @infeasible_rows << symbol
        end
      end

      dual_optimize
    end

    # Updates the values of the external solver variables
    #
    # ## Example
    #
    # ```
    # solver = Kiwi::Solver.new
    # x = Kiwi::Variable.new("x")
    # solver.add_constraint(x + 2 == 4)
    # solver.update_variables
    # x.value # => 2
    # ```
    def update_variables
      @vars.each do |variable, symbol|
        if !@rows.has_key?(symbol)
          variable.value = 0
        else
          variable.value = @rows[symbol].constant
        end
      end
    end

    # Creates a `Row` object for the given constraint
    private def create_row(constraint : Constraint, tag : Tag) : Row
      expression = constraint.expression
      row = Row.new(expression.constant)

      expression.terms.each do |term|
        if !Util.near_zero(term.coefficient)
          symbol = get_var_symbol(term.variable)
          if !@rows.has_key?(symbol)
            row.insert(symbol, term.coefficient)
          else
            row.insert(@rows[symbol], term.coefficient)
          end
        end
      end

      case constraint.op
      when RelationalOperator::OP_LE, RelationalOperator::OP_GE
        coeff = constraint.op == RelationalOperator::OP_LE ? 1.0 : -1.0
        slack = Symbol.new(Symbol::Type::SLACK)
        tag.marker = slack
        row.insert(slack, coeff)
        if constraint.strength < Strength::REQUIRED
          error = Symbol.new(Symbol::Type::ERROR)
          tag.other = error
          row.insert(error, -coeff)
          @objective.insert(error, constraint.strength)
        end
      when RelationalOperator::OP_EQ
        if constraint.strength < Strength::REQUIRED
          errplus = Symbol.new(Symbol::Type::ERROR)
          errminus = Symbol.new(Symbol::Type::ERROR)
          tag.marker = errplus
          tag.other = errminus
          row.insert(errplus, -1.0)
          row.insert(errminus, 1.0)
          @objective.insert(errplus, constraint.strength)
          @objective.insert(errminus, constraint.strength)
        else
          dummy = Symbol.new(Symbol::Type::DUMMY)
          tag.marker = dummy
          row.insert(dummy)
        end
      end

      if row.constant < 0
        row.reverse_sign
      end

      return row
    end

    # Chooses the best subject for the solve target of the row.
    # An invalid `Symbol` will be returned if there is no valid subject.
    private def choose_subject(row : Row, tag : Tag) : Symbol
      row.cells.each do |symbol, value|
        if symbol.type == Symbol::Type::EXTERNAL
          return symbol
        end
      end
      if tag.marker.type == Symbol::Type::SLACK || tag.marker.type == Symbol::Type::ERROR
        if row.coefficient_for(tag.marker) < 0
          return tag.marker
        end
      end
      if tag.other.type == Symbol::Type::SLACK || tag.other.type == Symbol::Type::ERROR
        if row.coefficient_for(tag.other) < 0
          return tag.other
        end
      end

      Symbol.new
    end

    # Adds the row to the table using an artificial variable.
    # This will return false if the constraint cannot be satisfied
    private def add_with_artificial_variable(row : Row) : Bool
      # create and add the artificial variable to the table
      art = Symbol.new(Symbol::Type::SLACK)
      @rows[art] = Row.new(row)

      @artificial = Row.new(row)

      # optimize the artificial objective. This is only successful
      # if the artificial objective is optimized to zero.
      optimize(@artificial.as(Row))
      success = Util.near_zero(@artificial.as(Row).constant)
      @artificial = nil

      # if the artificial variable is basic, pivot the row so that
      # it becomes basic. If the row is constant, exit early.

      if @rows.has_key? art
        rowptr = @rows[art]

        @rows.each_key do |symbol|
          if @rows[symbol] == rowptr
            @rows.delete symbol
          end
        end

        if rowptr.cells.empty?
          return success
        end

        entering = any_pivotable_symbol(rowptr)
        if entering.type == Symbol::Type::INVALID
          return false # unsatisfiable (will this ever happen?)
        end
        rowptr.solve_for(art, entering)
        substitute(entering, rowptr)
        @rows[entering] = rowptr
      end

      # remove the artificial variable from the table
      @rows.each_value do |value|
        value.remove(art)
      end

      @objective.remove(art)

      return success
    end

    # Substitute the parametric symbol with the given row.
    private def substitute(symbol : Symbol, row : Row)
      @rows.each do |key, value|
        value.substitute(symbol, row)
        if key.type != Symbol::Type::EXTERNAL && value.constant < 0
          @infeasible_rows << key
        end
      end

      @objective.substitute(symbol, row)

      if a = @artificial
        a.substitute(symbol, row)
      end
    end

    # Optimize the system for the given objective function.
    # This method performs iterations of Phase 2 of the simplex method
    # until the objective function reaches a minimum
    private def optimize(objective : Row)
      while true
        entering : Symbol = get_entering_symbol(objective)
        if entering.type == Symbol::Type::INVALID
          return
        end

        entry : Row = get_leaving_row(entering)
        # TODO: should leaving and entry_key be the same here?
        leaving : Symbol = get_row_symbol(entry)
        entry_key : Symbol = get_row_symbol(entry)

        @rows.delete entry_key
        entry.solve_for(leaving, entering)
        substitute(entering, entry)
        @rows[entering] = entry
      end
    end

    private def dual_optimize
      while !@infeasible_rows.empty?
        leaving : Symbol = @infeasible_rows.pop
        if @rows.has_key?(leaving) && @rows[leaving].constant < 0
          row = @rows[leaving]
          entering = get_dual_entering_symbol row
          if entering.type == Symbol::Type::INVALID
            raise InternalSolverError.new("internal solver error")
          end
          @rows.delete leaving
          row.solve_for(leaving, entering)
          substitute(entering, row)
          @rows[entering] = row
        end
      end
    end

    # Compute the entering variable for a pivot operation.
    private def get_entering_symbol(objective : Row) : Symbol
      objective.cells.each do |symbol, value|
        if symbol.type != Symbol::Type::DUMMY && value < 0
          return symbol
        end
      end
      Symbol.new
    end

    private def get_dual_entering_symbol(row : Row) : Symbol
      entering = Symbol.new
      ratio = Float64::MAX
      row.cells.each_key do |symbol|
        if symbol.type != Symbol::Type::DUMMY
          current_cell = row.cells[symbol]
          if current_cell > 0
            coefficient = @objective.coefficient_for(symbol)
            r = coefficient / current_cell
            if r < ratio
              ratio = r
              entering = symbol
            end
          end
        end
      end
      return entering
    end

    # Get the first slack or error `Symbol` in the *row*
    private def any_pivotable_symbol(row : Row) : Symbol
      row.cells.each_key do |s|
        if s.type == Symbol::Type::SLACK || s.type == Symbol::Type::ERROR
          return s
        end
      end
      Symbol.new
    end

    # Returns the *row*'s `Symbol`.
    # That is, the *row*'s key.
    private def get_row_symbol(row : Row) : Symbol
      @rows.each_key do |s|
        if @rows[s] == row
          return s
        end
      end
      raise InternalSolverError.new("internal solver error")
    end

    # Compute the `Row` which holds the exit `Symbol` for a pivot
    private def get_leaving_row(entering : Symbol) : Row
      ratio = Float64::MAX
      row : Row | Nil = nil
      @rows.each_key do |symbol|
        if symbol.type != Symbol::Type::EXTERNAL
          candidate_row = @rows[symbol]
          temp = candidate_row.coefficient_for entering
          if temp < 0
            temp_ratio = -candidate_row.constant / temp
            if temp_ratio < ratio
              ratio = temp_ratio
              row = candidate_row
            end
          end
        end
      end
      if result = row
        return result
      end
      raise InternalSolverError.new("The objective is unbounded.")
    end

    # Get the `Symbol` for the given *variable*
    # If a `Symbol` does not exist for the *variable*, one will be created.
    private def get_var_symbol(variable : VariableState) : Symbol
      if @vars.has_key?(variable)
        return @vars[variable]
      else
        symbol = Symbol.new(Symbol::Type::EXTERNAL)
        @vars[variable] = symbol
        return symbol
      end
    end

    # Test whether a *row* is composed of all dummy `Variable`'s
    private def all_dummies(row : Row) : Bool
      row.cells.each_key do |symbol|
        if symbol.type != Symbol::Type::DUMMY
          return false
        end
      end
      return true
    end
  end
end
