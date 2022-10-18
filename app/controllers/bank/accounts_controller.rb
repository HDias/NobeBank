module Bank
  class AccountsController < BaseController
    def index
      @accounts = ::Bank::Account.owner(current_user.id)
    end

    def show
      @account = find_by params[:id]
    end

    def create
      creator = ::Bank::CreateAccount.new(user_id: current_user.id)
      creator.save

      redirect_to bank_dashboards_path, notice: 'Account was successfully created.'
    rescue StandardError => e
      redirect_to bank_dashboards_path, alert: "Ops! #{e.message}"
    end

    def destroy
      @account = find_by params[:id]

      @account.destroy

      respond_to do |format|
        format.html { redirect_to bank_accounts_url, notice: 'Account was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def find_by(id)
      ::Bank::Account.find(id)
    end
  end
end
