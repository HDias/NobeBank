module Bank
  class AccountsController < ApplicationController
    def index
      @accounts = ::Bank::Account.all
    end

    def show
      set_account
    end

    def new
      @account = ::Bank::Account.new
    end

    def edit; end

    def create
      creator = ::Bank::CreateAccount.new(user_id: 1)

      respond_to do |format|
        if creator.valid? && creator.save
          format.html { redirect_to bank_account_url(creator.account_model), notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: creator.account_model }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: creator.account_model.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @account.update(account_params)
          format.html { redirect_to bank_account_url(@account), notice: 'Account was successfully updated.' }
          format.json { render :show, status: :ok, location: @account }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_account
      @account = ::Bank::Account.find(params[:id])
    end
  end
end
