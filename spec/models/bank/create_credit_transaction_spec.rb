require 'rails_helper'

RSpec.describe ::Bank::CreateCreditTransaction do
  context 'when initialize with wrong argument' do
    specify { expect { described_class.new(account_id: User.first) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(account_id: ::Bank::Account) }.to raise_error(ArgumentError) }
  end

  describe '.make' do
    context 'failure' do
      context 'when try make credit transaction how withdrawal' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_value   = 1

          expect do
            credit_creator.make(value: credit_value, nickname: 'withdrawal')
          end.to raise_error(ActiveRecord::RecordInvalid, /withdrawal is not valid to credit transaction/).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when account has been destroyed' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)
          account.destroy!

          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_value   = 1

          expect do
            credit_creator.make(value: credit_value, nickname: 'deposit')
          end.to raise_error(ActiveRecord::RecordNotFound).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when value is negative' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_value   = -1

          expect do
            credit_creator.make(value: credit_value, nickname: 'deposit')
          end.to raise_error(::Bank::NegativeValueError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when make deposit with positive value' do
        it 'expect to create deposit transaction and update balance' do
          account = create(:bank_account, balance: 0)
          user    = create(:user)

          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_value   = 10

          expect { credit_creator.make(value: credit_value, nickname: 'deposit') }.to change(::Bank::Transaction, :count).by(1)
          expect(account.reload.balance).to eq(credit_value)
        end

        it 'expect create bank_transaction with status success' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          credit_value   = 1
          credit_creator = described_class.new(account_id: account.id, user_id: user.id)
          credit_creator.make(value: credit_value, nickname: 'deposit')

          expect(credit_creator.transaction_model.success_status?).to be_truthy
        end
      end
    end
  end
end
