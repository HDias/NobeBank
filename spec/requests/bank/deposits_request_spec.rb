require 'rails_helper'

RSpec.describe ::Bank::DepositsController, type: :request do
  describe 'GET .new' do
    context 'not loged' do
      specify do
        get new_bank_deposit_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      specify do
        create(:bank_account)

        custom_sign_in create(:user)
        get new_bank_deposit_path

        expect(response).to be_successful
      end
    end
  end

  describe 'POST .create' do
    context 'not loged' do
      specify do
        create(:bank_account)

        post bank_deposits_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      context 'with valid parameters' do
        def deposit_param(account_id:, value:)
          { deposit: { account_id:, value: } }
        end

        it 'creates a new deposit transaction in your own account' do
          user       = create(:user)
          account_id = create(:bank_account, user:).id
          value      = rand(1..10)

          custom_sign_in create(:user)

          expect do
            post bank_deposits_url(deposit_param(account_id:, value:))
          end.to change(::Bank::Transaction.deposit, :count).by(1)
        end

        it 'update your own account balance with new value' do
          user    = create(:user)
          account = create(:bank_account, user:)
          value   = rand(1..10)

          custom_sign_in create(:user)

          post bank_deposits_url(deposit_param(account_id: account.id, value:))

          expect(account.reload.balance).to eq(value)
        end

        it 'redirects to the deposit transaction' do
          user       = create(:user)
          account_id = create(:bank_account, user:).id
          value      = rand(1..10)

          custom_sign_in create(:user)

          post bank_deposits_url(deposit_param(account_id:, value:))

          expect(response).to redirect_to(new_bank_deposit_path)
        end
      end

      context 'with invalid parameters' do
        def deposit_param(account_id:, value:)
          { deposit: { account_id:, value: } }
        end

        it "doesn't create a new deposit transaction" do
          user       = create(:user)
          account_id = create(:bank_account, user:).id
          value      = rand(-10..-0)

          custom_sign_in user

          expect do
            post bank_deposits_url(deposit_param(account_id:, value:))
          end.to change(::Bank::Transaction.deposit, :count).by(0)
        end

        it "doesn't update account balance with new value" do
          user    = create(:user)
          account = create(:bank_account, user:)
          value   = rand(-10..-1)

          custom_sign_in create(:user)

          post bank_deposits_url(deposit_param(account_id: account.id, value:))

          expect(account.reload.balance).to eq(0)
        end

        it 'redirects to the deposit transaction' do
          user       = create(:user)
          account_id = create(:bank_account, user:).id
          value      = rand(-10..-1)

          custom_sign_in create(:user)

          post bank_deposits_url(deposit_param(account_id:, value:))

          expect(response).to redirect_to(new_bank_deposit_path)
        end
      end
    end
  end
end
