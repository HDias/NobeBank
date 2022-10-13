module Bank
  class CreateDebitTransaction
    KIND = 'debit'.freeze

    attr_reader :transaction_model

    def initialize(account_id:, user_id:, transaction_model: ::Bank::Transaction)
      raise ArgumentError, "account_id should be 'Integer'" unless account_id.is_a?(Integer)
      raise ArgumentError, "user_id should be 'Integer'" unless user_id.is_a?(Integer)

      @transaction_model = transaction_model.new
      @account_id        = account_id
      @user_id           = user_id
    end

    def make(value:, nickname:)
      ActiveRecord::Base.transaction do
        verify_and_make_balance(value, nickname)
      end
    end

    private

    def verify_and_make_balance(value, nickname)
      raise ::Bank::NegativeValueError if value <= 0

      bank_account = ::Bank::Account.find(@account_id)

      raise ::Bank::InsufficientFundsError if bank_account.balance < value

      bank_account.balance = bank_account.balance - value
      bank_account.save!

      transaction(status: 'success', value:, nickname:).save!
    end

    def transaction(status:, value:, nickname:, description: nil)
      @transaction_model.kind             = KIND
      @transaction_model.status           = status
      @transaction_model.nickname         = nickname
      @transaction_model.description      = description
      @transaction_model.value            = value
      @transaction_model.bank_account_id  = @account_id
      @transaction_model.user_id          = @user_id

      @transaction_model
    end
  end
end
