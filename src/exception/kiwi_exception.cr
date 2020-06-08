module Kiwi
  # TODO: do we actually need this?
  class KiwiException < Exception
    def initialize
    end

    def initialize(message : String)
      super(message)
    end
  end
end
