module Bank
  class AccountsController < BaseController
    def create
      creator = ::Bank::CreateAccount.new(user_id: current_user.id)
      creator.save

      redirect_to bank_dashboards_url, notice: 'Oba! Conta criada com sucesso! Aproveite!'
    rescue StandardError => e
      redirect_to bank_dashboards_url, alert: "Ops! #{e.message}"
    end

    def destroy
      @account = find_by params[:id]

      @account.destroy

      redirect_to bank_dashboards_url, notice: 'Que pena! Sua conta foi encerrada!'
    rescue StandardError => e
      redirect_to bank_dashboards_url, alert: "Ops! #{e.message}"
    end

    private

    def find_by(id)
      ::Bank::Account.owner(current_user.id).find(id)
    end
  end
end
