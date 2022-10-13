module Bank
  class InsufficientFundsError < StandardError
    def initialize(msg = 'Your account has insufficient funds for transaction')
      super
    end
  end
end
