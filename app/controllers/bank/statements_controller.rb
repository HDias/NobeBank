module Bank
  class StatementsController < BaseController
    def index
      @current_account = ::Bank::Account.owner(current_user.id).find(params[:current_account_id])

      @statements = []
    rescue StandardError => e
      redirect_to bank_dashboards_path, alert: "Ops! #{e.message}"
    end
  end
end
