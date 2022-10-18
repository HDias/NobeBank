module Bank
  class TransfersController < BaseController
    def new
      @current_account = ::Bank::Account.owner(current_user.id).find(params[:current_account_id])

      @accounts = ::Bank::Account.owner(current_user.id).where.not(id: params[:current_account_id])
    rescue StandardError => e
      redirect_to bank_dashboards_path, alert: "Ops! #{e.message}"
    end

    def create
      credit_creator = ::Bank::CreateTransferTransaction.new(
        from_id: transfer_initialize_params[:from_id].to_i,
        to_id: transfer_initialize_params[:to_id].to_i
      )
      credit_creator.make(value: transfer_make_params[:value].to_i)

      redirect_to new_bank_transfer_path(current_account_id: transfer_initialize_params[:from_id]),
                  notice: 'Oba! Transferência realizada com sucesso!'
    rescue StandardError => e
      redirect_to new_bank_transfer_path(
        current_account_id: transfer_initialize_params[:from_id],
        to_id: params[:to_id]
      ), alert: "Ops! #{e.message}"
    end

    private

    def transfer_initialize_params
      params.require(:transfer)
            .permit(:from_id, :to_id)
    end

    def transfer_make_params
      params.require(:transfer)
            .permit(:value)
            .merge(nickname: 'transfer')
    end
  end
end
