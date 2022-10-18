module Bank
  class NegativeValueError < ArgumentError
    def initialize(msg = 'Somente valores positivos!')
      super
    end
  end
end
