module Bank
  class WithdrawalsController < BaseController
    def new
      @accounts = ::Bank::Account.owner(current_user.id)
    end

    def create
      credit_creator = ::Bank::CreateDebitTransaction.new(
        account_id: withdrawal_initialize_params[:account_id].to_i,
        user_id: withdrawal_initialize_params[:user_id].to_i
      )
      credit_creator.make(value: withdrawal_make_params[:value].to_i, nickname: withdrawal_make_params[:nickname])

      redirect_to new_bank_withdrawal_path(account_id: withdrawal_initialize_params[:account_id]), notice: 'Withdrawal was successfully created.'
    rescue StandardError => e
      redirect_to new_bank_withdrawal_path(account_id: withdrawal_initialize_params[:account_id]), alert: "Ops! #{e.message}"
    end

    def destroy
      @account = find_by params[:id]

      @account.destroy

      respond_to do |format|
        format.html { redirect_to bank_accounts_url, notice: 'Transaction was successfully destroyed.' }
        format.json { head :no_content }
      end
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
