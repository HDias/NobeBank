require 'rails_helper'

RSpec.describe ::Bank::TransfersController, type: :request do
  describe 'GET .new' do
    context 'not loged' do
      specify do
        create(:bank_account)

        get new_bank_transfer_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      specify do
        user = create(:user)
        create(:bank_account, user:)

        custom_sign_in user

        get new_bank_transfer_path

        expect(response).to redirect_to(bank_dashboards_url)
      end
    end

    context 'loged without current_account_id query param' do
      specify do
        user = create(:user)
        account = create(:bank_account, user:)

        custom_sign_in user

        get new_bank_transfer_path(current_account_id: account.id)

        expect(response).to be_successful
      end
    end
  end

  describe 'POST .create' do
    context 'not loged' do
      specify do
        create(:bank_account)

        post bank_transfers_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged with balance' do
      context 'with valid parameters' do
        def transfer_params(from_id:, to_id:, value:)
          { transfer: { from_id:, to_id:, value: } }
        end

        it 'creates a new transfer transaction in your own account' do
          user    = create(:user)
          from_id = create(:bank_account, user:, balance: 11).id
          to_id   = create(:bank_account, user:).id
          value   = rand(1..10)

          custom_sign_in create(:user)

          expect do
            post bank_transfers_url(transfer_params(from_id:, to_id:, value:))
          end.to change(::Bank::Transaction.transfer, :count).by(2)
             .and change(::Bank::Transaction.credit_kind, :count).by(1)
             .and change(::Bank::Transaction.debit_kind, :count).by(1)
        end

        it 'update two own account balances with new value' do
          user         = create(:user)
          from_account = create(:bank_account, user:, balance: 11)
          to_account   = create(:bank_account, user:)
          value        = rand(1..10)

          custom_sign_in create(:user)
          post bank_transfers_url(transfer_params(from_id: from_account.id, to_id: to_account.id, value:))

          old_from_balance = from_account.balance
          old_to_balance   = to_account.balance

          expect(from_account.reload.balance).to eq(old_from_balance - value)
          expect(to_account.reload.balance).to eq(old_to_balance + value)
        end

        it 'redirects to the transfer transaction' do
          user         = create(:user)
          from_account = create(:bank_account, user:, balance: 11)
          to_account   = create(:bank_account, user:)
          value        = rand(1..10)

          custom_sign_in create(:user)
          post bank_transfers_url(transfer_params(from_id: from_account.id, to_id: to_account.id, value:))

          expect(response).to redirect_to(new_bank_transfer_path(current_account_id: from_account.id))
        end
      end

      context 'with invalid parameters' do
        def transfer_params(from_id:, to_id:, value:)
          { transfer: { from_id:, to_id:, value: } }
        end

        it "doesn't create a new transfer transaction" do
          user    = create(:user)
          from_id = create(:bank_account, user:, balance: 11).id
          to_id   = create(:bank_account, user:).id
          value   = rand(-10..-1)

          custom_sign_in create(:user)

          expect do
            post bank_transfers_url(transfer_params(from_id:, to_id:, value:))
          end.to change(::Bank::Transaction.transfer, :count).by(0)
             .and change(::Bank::Transaction.credit_kind, :count).by(0)
             .and change(::Bank::Transaction.debit_kind, :count).by(0)
        end

        it "doesn't update account balance with new value" do
          user         = create(:user)
          from_account = create(:bank_account, user:, balance: 11)
          to_account   = create(:bank_account, user:)
          value        = rand(-10..-1)

          custom_sign_in create(:user)
          post bank_transfers_url(transfer_params(from_id: from_account.id, to_id: to_account.id, value:))

          expect(from_account.reload.balance).to eq(11)
          expect(to_account.reload.balance).to eq(0)
        end

        it 'redirects to the transfer transaction' do
          user         = create(:user)
          from_account = create(:bank_account, user:, balance: 11)
          to_account   = create(:bank_account, user:)
          value        = rand(-10..-1)

          custom_sign_in create(:user)
          post bank_transfers_url(transfer_params(from_id: from_account.id, to_id: to_account.id, value:))

          expect(response).to redirect_to(new_bank_transfer_path(current_account_id: from_account.id))
        end
      end
    end
  end
end
