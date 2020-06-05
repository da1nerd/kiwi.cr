module Kiwi
  class Symbol
    enum Type
      INVALID
      EXTERNAL
      SLACK
      ERROR
      DUMMY
    end

    @type : Type

    getter type

    def initialize
      initialize(Type::INVALID)
    end

    def initialize(@type : Type)
    end
  end
end
