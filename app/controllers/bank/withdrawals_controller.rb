module Bank
  class WithdrawalsController < BaseController
    def new
      @accounts = ::Bank::Account.owner(current_user.id)
    rescue StandardError => e
      redirect_to bank_dashboards_path, alert: "Ops! #{e.message}"
    end

    def create
      credit_creator = ::Bank::CreateDebitTransaction.new(
        account_id: withdrawal_initialize_params[:account_id].to_i,
        user_id: withdrawal_initialize_params[:user_id].to_i
      )
      credit_creator.make(value: withdrawal_make_params[:value].to_i, nickname: withdrawal_make_params[:nickname])

      redirect_to new_bank_withdrawal_path(
        account_id: withdrawal_initialize_params[:account_id]
      ), notice: 'Withdrawal was successfully created.'
    rescue StandardError => e
      redirect_to new_bank_withdrawal_path(
        account_id: withdrawal_initialize_params[:account_id]
      ), alert: "Ops! #{e.message}"
    end

    private

    def withdrawal_initialize_params
      params.require(:withdrawal)
            .permit(:account_id)
            .merge(user_id: current_user.id)
    end

    def withdrawal_make_params
      params.require(:withdrawal)
            .permit(:value)
            .merge(nickname: 'withdrawal')
    end
  end
end
