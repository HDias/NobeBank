require 'rails_helper'

RSpec.describe ::Bank::WithdrawalsController, type: :request do
  describe 'GET .new' do
    context 'not loged' do
      specify do
        get new_bank_withdrawal_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      specify do
        create(:bank_account)

        custom_sign_in create(:user)
        get new_bank_withdrawal_path

        expect(response).to be_successful
      end
    end
  end

  describe 'POST .create' do
    context 'not loged' do
      specify do
        create(:bank_account)

        post bank_withdrawals_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      context 'with valid parameters and sufficient funds' do
        def withdrawal_param(account_id:, value:)
          { withdrawal: { account_id:, value: } }
        end

        it 'creates a new withdrawal transaction in your own account' do
          user       = create(:user)
          account_id = create(:bank_account, user:, balance: 11).id
          value      = rand(1..10)

          custom_sign_in create(:user)

          expect do
            post bank_withdrawals_url(withdrawal_param(account_id:, value:))
          end.to change(::Bank::Transaction.withdrawal, :count).by(1)
        end

        it 'update your own account balance with new value' do
          user    = create(:user)
          balance = 11
          account = create(:bank_account, user:, balance:)
          value   = rand(1..10)

          custom_sign_in create(:user)

          post bank_withdrawals_url(withdrawal_param(account_id: account.id, value:))

          expect(account.reload.balance).to eq(balance - value)
        end

        it 'redirects to the withdrawal transaction' do
          user       = create(:user)
          account_id = create(:bank_account, user:, balance: 11).id
          value      = rand(1..10)

          custom_sign_in create(:user)

          post bank_withdrawals_url(withdrawal_param(account_id:, value:))

          expect(response).to redirect_to(new_bank_withdrawal_path(account_id:))
        end
      end

      context 'with valid parameters and insufficient funds' do
        def withdrawal_param(account_id:, value:)
          { withdrawal: { account_id:, value: } }
        end

        it "doesn't creates a new withdrawal transaction in your own account" do
          user       = create(:user)
          account_id = create(:bank_account, user:, balance: 0).id
          value      = rand(1..10)

          custom_sign_in create(:user)

          expect do
            post bank_withdrawals_url(withdrawal_param(account_id:, value:))
          end.to change(::Bank::Transaction.withdrawal, :count).by(0)
        end

        it "doesn't update your own account balance with new value" do
          user    = create(:user)
          balance = 0
          account = create(:bank_account, user:, balance:)
          value   = rand(1..10)

          custom_sign_in create(:user)

          post bank_withdrawals_url(withdrawal_param(account_id: account.id, value:))

          expect(account.reload.balance).to eq(balance)
        end
      end

      context 'with invalid parameters' do
        def withdrawal_param(account_id:, value:)
          { withdrawal: { account_id:, value: } }
        end

        it "doesn't create a new withdrawal transaction" do
          user       = create(:user)
          account_id = create(:bank_account, user:, balance: 11).id
          value      = rand(-10..-0)

          custom_sign_in user

          expect do
            post bank_withdrawals_url(withdrawal_param(account_id:, value:))
          end.to change(::Bank::Transaction.withdrawal, :count).by(0)
        end

        it "doesn't update account balance with new value" do
          user    = create(:user)
          account = create(:bank_account, user:, balance: 11)
          value   = rand(-10..-1)

          custom_sign_in create(:user)

          post bank_withdrawals_url(withdrawal_param(account_id: account.id, value:))

          expect(account.reload.balance).to eq(11)
        end

        it 'redirects to the withdrawal transaction' do
          user       = create(:user)
          account_id = create(:bank_account, user:, balance: 11).id
          value      = rand(-10..-1)

          custom_sign_in create(:user)

          post bank_withdrawals_url(withdrawal_param(account_id:, value:))

          expect(response).to redirect_to((new_bank_withdrawal_path(account_id:)))
        end
      end
    end
  end
end
