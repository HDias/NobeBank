module Bank
  class TranfersController < BaseController
    def new
      @account = ::Bank::Transaction.new
    end

    def create
      creator = ::Bank::CreateTransaction.new(user_id: current_user.id)

      respond_to do |format|
        if creator.save
          format.html do
            redirect_to bank_account_url(creator.account_model), notice: 'Transaction was successfully created.'
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
        format.html { redirect_to bank_accounts_url, notice: 'Transaction was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def find_by(id)
      ::Bank::Transaction.find(id)
    end
  end
end
