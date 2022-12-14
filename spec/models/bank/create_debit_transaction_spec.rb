require 'rails_helper'

RSpec.describe ::Bank::CreateDebitTransaction do
  context 'when initialize with wrong argument' do
    specify { expect { described_class.new(account_id: User.first) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(account_id: ::Bank::Account) }.to raise_error(ArgumentError) }
  end

  describe '.make' do
    context 'failure' do
      context 'when try make debit transaction how deposit' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_creator = described_class.new(account_id: account.id, user_id: user.id)
          debit_value   = 1

          expect do
            debit_creator.make(value: debit_value, nickname: 'deposit')
          end.to raise_error(ActiveRecord::RecordInvalid).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when account balance is 0 and try debit value' do
        specify do
          account = create(:bank_account, balance: 0)
          user    = create(:user)

          debit_creator = described_class.new(account_id: account.id, user_id: user.id)
          debit_value   = 1

          expect do
            debit_creator.make(value: debit_value, nickname: 'withdrawal')
          end.to raise_error(::Bank::InsufficientFundsError).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when account has been destroyed' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)
          account.destroy!

          debit_creator = described_class.new(account_id: account.id, user_id: user.id)
          debit_value   = 1

          expect do
            debit_creator.make(value: debit_value, nickname: 'withdrawal')
          end.to raise_error(ActiveRecord::RecordNotFound).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when value is negative' do
        specify do
          account = create(:bank_account, balance: 0)
          user    = create(:user)

          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_value   = -1

          expect do
            credit_creator.make(value: credit_value, nickname: 'withdrawal')
          end.to raise_error(::Bank::NegativeValueError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when account balance has sufficienty funds' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_creator = described_class.new(account_id: account.id, user_id: user.id)
          debit_value   = 1

          expect { debit_creator.make(value: debit_value, nickname: 'withdrawal') }.to change(::Bank::Transaction, :count).by(1)
        end

        it 'expect create bank_transaction with status success' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_value   = 1
          debit_creator = described_class.new(account_id: account.id, user_id: user.id)
          debit_creator.make(value: debit_value, nickname: 'withdrawal')

          expect(debit_creator.transaction_model.success_status?).to be_truthy
        end
      end
    end
  end
end
