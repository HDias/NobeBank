module Bank
  class CreateTransferTransaction
    KIND = 'credit'.freeze

    attr_reader :transaction_model

    def initialize(from_id:, to_id:)
      raise ArgumentError, "from_id should be 'Integer'" unless from_id.is_a?(Integer)
      raise ArgumentError, "to_id should be 'Integer'" unless to_id.is_a?(Integer)

      @from_id        = from_id
      @to_id          = to_id
    end

    def make(value:)
      ActiveRecord::Base.transaction do
        make_transfer(value)
      end
    end

    private

    def make_transfer(value)
      raise ::Bank::NegativeValueError if value <= 0

      debit_creator = ::Bank::CreateDebitTransaction.new(account_id: @from_id, user_id: debit_account_user_id)
      debit_creator.make(value:, nickname: 'transfer')

      credit_creator = ::Bank::CreateCreditTransaction.new(account_id: @to_id, user_id: debit_account_user_id)
      credit_creator.make(value:, nickname: 'transfer')
    end

    def debit_account_user_id
      ::Bank::Account.find(@from_id).user.id
    end
  end
end
