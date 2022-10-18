module Bank
  class InsufficientFundsError < StandardError
    def initialize(msg = 'Sua conta não tem saldo para realizar essa transação')
      super
    end
  end
end
