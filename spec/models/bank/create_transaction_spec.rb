require 'rails_helper'

RSpec.describe ::Bank::CreateTransaction do
  describe 'failue' do
    context 'when initialize with wrong argument' do
      specify { expect { described_class.new(bank_account: User.first) }.to raise_error(ArgumentError) }
      specify { expect { described_class.new(bank_account: ::Bank::Account) }.to raise_error(ArgumentError) }
    end

    context 'when account balance is 0 and try debit value' do
      specify do
        account = create(:bank_account, balance: 0)
        user    = create(:user)

        creator     = described_class.new(bank_account: account, user:)
        debit_value = 1

        expect do
          creator.debit(debit_value)
        end.to raise_error(::Bank::InsufficientFundsError).and change(::Bank::Transaction, :count).by(0)
      end
    end
  end

  describe 'success' do
    context 'when account balance has sufficienty funds' do
      specify do
        account = create(:bank_account, balance: 1)
        user    = create(:user)

        creator     = described_class.new(bank_account: account, user:)
        debit_value = 1

        expect { creator.debit(debit_value) }.to change(::Bank::Transaction, :count).by(1)
      end

      it 'expect create bank_transaction with status sucess' do
        account = create(:bank_account, balance: 1)
        user    = create(:user)

        debit_value = 1
        creator     = described_class.new(bank_account: account, user:)
        creator.debit(debit_value)

        expect(creator.transaction_model.success_status?).to be_truthy
      end
    end
  end
end
