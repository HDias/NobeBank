module Bank
  class CreateTransaction
    attr_reader :transaction_model, :user_id

    def initialize(transaction_model: ::Bank::Transaction)
      @transaction_model = transaction_model.new
    end

    def valid?
      @transaction_model.account_number = ::Bank::AccountNumber.generate
      @transaction_model.agency         = ::Bank::AgencyNumber.get
      @transaction_model.user_id        = @user_id

      @transaction_model.valid?
    end

    def save
      return unless valid?

      @transaction_model.save!
    end
  end
end
