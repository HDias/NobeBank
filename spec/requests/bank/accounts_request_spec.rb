require 'rails_helper'

RSpec.describe ::Bank::AccountsController, type: :request do
  describe 'POST /create' do
    context 'not loged' do
      it 'redirect do login pat' do
        post bank_accounts_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
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

          expect(response).to redirect_to(bank_dashboards_path)
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'not loged' do
      it 'redirect do login pat' do
        account = create(:bank_account)

        delete bank_account_url(account)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      context 'when user wants close own account' do
        it 'destroys the requested account' do
          user = create(:user)
          account = create(:bank_account, user:)

          custom_sign_in user

          expect do
            delete bank_account_url(account)
          end.to change(::Bank::Account, :count).by(-1)
        end

        it 'redirects to the accounts list' do
          user    = create(:user)
          account = create(:bank_account, user:)

          custom_sign_in user

          delete bank_account_url(account)

          expect(response).to redirect_to(bank_dashboards_url)
        end
      end

      context 'when user wants close account from other user' do
        it 'destroys the requested account' do
          first_user = create(:user)
          first_user_account = create(:bank_account, user: first_user)

          second_user = create(:user)
          custom_sign_in second_user

          expect do
            delete bank_account_url(first_user_account)
          end.to change(::Bank::Account, :count).by(0)
        end
      end
    end
  end
end
