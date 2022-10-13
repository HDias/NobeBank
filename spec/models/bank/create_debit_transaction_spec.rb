require 'rails_helper'

RSpec.describe ::Bank::CreateDebitTransaction do
  context 'when initialize with wrong argument' do
    specify { expect { described_class.new(bank_account: User.first) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(bank_account: ::Bank::Account) }.to raise_error(ArgumentError) }
  end

  describe '.make' do
    context 'failure' do
      context 'when account balance is 0 and try debit value' do
        specify do
          account = create(:bank_account, balance: 0)
          user    = create(:user)

          debit_creator = described_class.new(bank_account: account, user:)
          debit_value   = 1

          expect do
            debit_creator.make(value: debit_value, nickname: 'withdrawal')
          end.to raise_error(::Bank::InsufficientFundsError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when account balance has sufficienty funds' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_creator = described_class.new(bank_account: account, user:)
          debit_value   = 1

          expect { debit_creator.make(value: debit_value, nickname: 'withdrawal') }.to change(::Bank::Transaction, :count).by(1)
        end

        it 'expect create bank_transaction with status sucess' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_value   = 1
          debit_creator = described_class.new(bank_account: account, user:)
          debit_creator.make(value: debit_value, nickname: 'withdrawal')

          expect(debit_creator.transaction_model.success_status?).to be_truthy
        end
      end
    end
  end

  describe '.credit' do
    context 'failure' do
      context 'when account balance is 0 and try debit value' do
        specify do
          account = create(:bank_account, balance: 0)
          user    = create(:user)

          debit_creator = described_class.new(bank_account: account, user:)
          debit_value   = 1

          expect do
            debit_creator.make(value: debit_value, nickname: 'withdrawal')
          end.to raise_error(::Bank::InsufficientFundsError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'make withdrawal when account balance has sufficienty funds' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_creator = described_class.new(bank_account: account, user:)
          debit_value   = 1

          expect { debit_creator.make(value: debit_value, nickname: 'withdrawal') }.to change(::Bank::Transaction, :count).by(1)
        end

        it 'expect create bank_transaction with status success and nickname is withdrawal' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_value   = 1
          debit_creator = described_class.new(bank_account: account, user:)
          debit_creator.make(value: debit_value, nickname: 'withdrawal')

          expect(debit_creator.transaction_model.success_status?).to be_truthy
          expect(debit_creator.transaction_model.withdrawal?).to be_truthy
        end

        it 'expect create bank_transaction with status success and nickname is transfer' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          debit_value   = 1
          debit_creator = described_class.new(bank_account: account, user:)
          debit_creator.make(value: debit_value, nickname: 'transfer')

          expect(debit_creator.transaction_model.success_status?).to be_truthy
          expect(debit_creator.transaction_model.transfer?).to be_truthy
        end
      end
    end
  end
end
