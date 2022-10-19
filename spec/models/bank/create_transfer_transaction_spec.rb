require 'rails_helper'

RSpec.describe ::Bank::CreateTransferTransaction do
  context 'when initialize with wrong argument' do
    specify { expect { described_class.new(from_id: 'String') }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(to_id: 'String') }.to raise_error(ArgumentError) }
  end

  describe '.make' do
    context 'failure' do
      context 'when debit account balance is 0 and try transfer' do
        specify do
          debit_account = create(:bank_account, balance: 0)
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(::Bank::InsufficientFundsError).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when debit account has been destroyed' do
        specify do
          debit_account = create(:bank_account, balance: 18)
          debit_account.destroy!
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(ActiveRecord::RecordNotFound)
             .and change(::Bank::Transaction.transfer, :count).by(0)
             .and change(::Bank::Transaction.tax, :count).by(0)
        end
      end

      context 'when credit account has been destroyed' do
        specify do
          debit_account = create(:bank_account, balance: 18)
          credit_account = create(:bank_account, balance: 0)
          credit_account.destroy!

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(ActiveRecord::RecordNotFound)
             .and change(::Bank::Transaction.transfer, :count).by(0)
             .and change(::Bank::Transaction.tax, :count).by(0)
        end
      end

      context 'when value is negative' do
        specify do
          debit_account  = create(:bank_account, balance: 18)
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = -1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(::Bank::NegativeValueError)
             .and change(::Bank::Transaction.transfer, :count).by(0)
             .and change(::Bank::Transaction.tax, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when account balance has sufficienty funds' do
        def get_tax(value:)
          calculator = ::Bank::TaxValueTransfer.new

          calculator.get(value:)
        end

        it 'expect change balance in credit and in debit account' do
          debit_balance = 18
          debit_account  = create(:bank_account, balance: debit_balance)
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to change(::Bank::Transaction.transfer, :count).by(2)
             .and change(::Bank::Transaction.tax, :count).by(1)

          to_account_balanceless_tax = debit_balance - get_tax(value: transfer_value)

          expect(debit_account.reload.balance).to eq(to_account_balanceless_tax - transfer_value)
          expect(credit_account.reload.balance).to eq(1)
        end
      end
    end
  end
end
