module Bank
  class AccountsController < ApplicationController
    def index
      @accounts = ::Bank::Account.all
    end

    def show
      @account = find_by params[:id]
    end

    def new
      @account = ::Bank::Account.new
    end

    def edit
      @account = find_by params[:id]
    end

    def create
      creator = ::Bank::CreateAccount.new(user_id: current_user.id)

      respond_to do |format|
        if creator.save
          format.html do
            redirect_to bank_account_url(creator.account_model), notice: 'Account was successfully created.'
          end
          format.json { render :show, status: :created, location: creator.account_model }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: creator.account_model.errors, status: :unprocessable_entity }
        end
      end
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
