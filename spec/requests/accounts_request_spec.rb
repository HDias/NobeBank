require 'rails_helper'

RSpec.describe ::Bank::AccountsController, type: :request do
  describe 'GET /index' do
    it 'renders a successful response' do
      create(:bank_account)

      get bank_accounts_url

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      account = create(:bank_account)

      get bank_account_url(account)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_bank_account_url

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Account' do
        expect do
          post bank_accounts_url
        end.to change(::Bank::Account, :count).by(1)
      end

      it 'redirects to the created account' do
        post bank_accounts_url

        expect(response).to redirect_to(bank_account_url(::Bank::Account.last))
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user wants close account' do
      it 'destroys the requested account' do
        account = create(:bank_account)

        expect do
          delete bank_account_url(account)
        end.to change(::Bank::Account, :count).by(-1)
      end

      it 'redirects to the accounts list' do
        account = create(:bank_account)

        delete bank_account_url(account)

        expect(response).to redirect_to(bank_accounts_url)
      end
    end
  end
end
