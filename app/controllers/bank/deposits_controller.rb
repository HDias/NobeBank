module Bank
  class DepositsController < BaseController
    def new
      @account = ::Bank::Transaction.new
    end

    def create
      credit_creator = described_class.new(deposit_initialize_params)

      respond_to do |format|
        if credit_creator.make(deposit_make_params)
          format.html do
            redirect_to bank_account_url(credit_creator.transaction_model), notice: 'Transaction was successfully created.'
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
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

    def find_by(id)
      ::Bank::Transaction.deposit.find(id)
    end

    def deposit_initialize_params
      params.require(:deposit)
            .permit(:account_id)
            .merge(user_id: current_user.id)
    end

    def deposit_make_params
      params.require(:deposit)
            .permit(:value, nickname: 'deposit')
    end
  end
end
