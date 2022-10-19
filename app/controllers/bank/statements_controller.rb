module Bank
  class StatementsController < BaseController
    def index
      @current_account = ::Bank::Account.owner(current_user.id).find(params[:current_account_id])

      @report_transaction = ::Report::Transaction.new(
        account_id: @current_account.id,
        start_date: filter_pamas[:start_date],
        end_date: filter_pamas[:end_date]
      )

      @report_transaction.generate
    rescue StandardError => e
      redirect_to bank_dashboards_url, alert: "Ops! #{e.message}"
    end

    private

    def filter_pamas
      params.permit(:start_date, :end_date)
            .merge(start_date: params.dig(:statement, :start_date))
            .merge(end_date: params.dig(:statement, :end_date))
    end
  end
end
