module Bank
  class NegativeValueError < ArgumentError
    def initialize(msg = 'Transaction value should be positive')
      super
    end
  end
end
