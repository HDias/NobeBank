module Bank
  class CreateTransaction
    attr_reader :transaction_model, :bank_account

    def initialize(bank_account:, user:, transaction_model: ::Bank::Transaction)
      raise ArgumentError, "bank_account can be '::Bank::Account' model" unless bank_account.is_a?(::Bank::Account)
      raise ArgumentError, "user can be ':User' model" unless user.is_a?(::User)

      @transaction_model = transaction_model.new
      @bank_account      = bank_account
      @user              = user
    end

    def debit(value)
      verify_and_make_balance(value)
    end

    private

    def verify_and_make_balance(value)
      raise ::Bank::InsufficientFundsError if @bank_account.balance < value

      @bank_account.balance = @bank_account.balance - value
      @bank_account.save!

      transaction(status: 'success', value:).save!
    end

    def transaction(status:, value:, description: nil)
      @transaction_model.kind         = 'debit'
      @transaction_model.status       = status
      @transaction_model.description  = description
      @transaction_model.value        = value
      @transaction_model.bank_account = @bank_account
      @transaction_model.user         = @user

      @transaction_model
    end
  end
end
