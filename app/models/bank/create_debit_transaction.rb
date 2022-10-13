module Bank
  class CreateDebitTransaction
    attr_reader :transaction_model, :bank_account, :nickname

    def initialize(bank_account:, user:, transaction_model: ::Bank::Transaction)
      raise ArgumentError, "bank_account can be '::Bank::Account' model" unless bank_account.is_a?(::Bank::Account)
      raise ArgumentError, "user can be ':User' model" unless user.is_a?(::User)

      @transaction_model = transaction_model.new
      @bank_account      = bank_account
      @user              = user
    end

    def make(value:, nickname:)
      ActiveRecord::Base.transaction do
        verify_and_make_balance(value, nickname)
      end
    end

    private

    def verify_and_make_balance(value, nickname)
      raise ::Bank::InsufficientFundsError if @bank_account.balance < value

      @bank_account.balance = @bank_account.balance - value
      @bank_account.save!

      transaction(status: 'success', value:, nickname:).save!
    end

    def transaction(status:, value:, nickname:, description: nil)
      @transaction_model.kind         = 'debit'
      @transaction_model.status       = status
      @transaction_model.nickname     = nickname
      @transaction_model.description  = description
      @transaction_model.value        = value
      @transaction_model.bank_account = @bank_account
      @transaction_model.user         = @user

      @transaction_model
    end
  end
end
