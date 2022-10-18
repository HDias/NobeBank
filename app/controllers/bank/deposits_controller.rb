module Bank
  class DepositsController < BaseController
    def new
      @accounts = ::Bank::Account.owner(current_user.id)

    rescue StandardError => e
      redirect_to bank_dashboards_path, alert: "Ops! #{e.message}"
    end

    def create
      credit_creator = ::Bank::CreateCreditTransaction.new(
        account_id: deposit_initialize_params[:account_id].to_i,
        user_id: deposit_initialize_params[:user_id].to_i
      )
      credit_creator.make(value: deposit_make_params[:value].to_i, nickname: deposit_make_params[:nickname])

      redirect_to new_bank_deposit_path, notice: 'Deposit was successfully created.'
    rescue StandardError => e
      redirect_to new_bank_deposit_path, alert: "Ops! #{e.message}"
    end

    private

    def deposit_initialize_params
      params.require(:deposit)
            .permit(:account_id)
            .merge(user_id: current_user.id)
    end

    def deposit_make_params
      params.require(:deposit)
            .permit(:value)
            .merge(nickname: 'deposit')
    end
  end
end
