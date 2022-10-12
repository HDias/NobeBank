require 'rails_helper'

RSpec.describe ::Bank::AccountsController, type: :request do
  context 'loged' do
    describe 'GET /index' do
      it 'renders a successful response' do
        create(:bank_account)

        custom_sign_in create(:user)
        get bank_accounts_url

        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        account = create(:bank_account)

        custom_sign_in create(:user)
        get bank_account_url(account)

        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        custom_sign_in create(:user)
        get new_bank_account_url

        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Account' do
          custom_sign_in create(:user)

          expect do
            post bank_accounts_url
          end.to change(::Bank::Account, :count).by(1)
        end

        it 'redirects to the created account' do
          custom_sign_in create(:user)
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
            custom_sign_in create(:user)
            delete bank_account_url(account)
          end.to change(::Bank::Account, :count).by(-1)
        end

        it 'redirects to the accounts list' do
          account = create(:bank_account)

          custom_sign_in create(:user)
          delete bank_account_url(account)

          expect(response).to redirect_to(bank_accounts_url)
        end
      end
    end
  end
end
