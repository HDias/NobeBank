module Bank
  class CreateCreditTransaction
    attr_reader :transaction_model, :account_id, :nickname

    def initialize(account_id:, user:, transaction_model: ::Bank::Transaction)
      raise ArgumentError, "account_id should be 'Integer'" unless account_id.is_a?(Integer)
      raise ArgumentError, "user should be 'User' model" unless user.is_a?(::User)

      @transaction_model = transaction_model.new
      @account_id        = account_id
      @user              = user
    end

    def make(value:, nickname:)
      ActiveRecord::Base.transaction do
        make_balance(value, nickname)
      end
    end

    private

    def make_balance(value, nickname)
      raise ::Bank::NegativeValueError if value <= 0

      bank_account = ::Bank::Account.find(@account_id)

      raise ::Bank::InsufficientFundsError if bank_account.balance < value

      bank_account.balance = bank_account.balance - value
      bank_account.save!

      transaction(status: 'success', value:, nickname:).save!
    end

    def transaction(status:, value:, nickname:, description: nil)
      @transaction_model.kind         = 'debit'
      @transaction_model.status       = status
      @transaction_model.nickname     = nickname
      @transaction_model.description  = description
      @transaction_model.value        = value
      @transaction_model.account_id = @account_id
      @transaction_model.user         = @user

      @transaction_model
    end
  end
end
