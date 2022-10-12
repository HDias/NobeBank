module Bank
  class CreateAccount
    attr_reader :account_model, :user_id

    def initialize(account_model: ::Bank::Account, user_id: nil)
      @account_model = account_model.new
      @user_id       = user_id
    end

    def valid?
      @account_model.account_number = ::Bank::AccountNumber.generate
      @account_model.agency         = ::Bank::AgencyNumber.get
      @account_model.user_id        = @user_id

      @account_model.valid?
    end

    def save
      return unless valid?

      @account_model.save!
    end
  end
end
