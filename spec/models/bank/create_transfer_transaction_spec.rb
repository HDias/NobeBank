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
          debit_account = create(:bank_account, balance: 1)
          debit_account.destroy!
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(ActiveRecord::RecordNotFound).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when credit account has been destroyed' do
        specify do
          debit_account = create(:bank_account, balance: 1)
          credit_account = create(:bank_account, balance: 0)
          credit_account.destroy!

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(ActiveRecord::RecordNotFound).and change(::Bank::Transaction, :count).by(0)
        end
      end

      context 'when value is negative' do
        specify do
          debit_account  = create(:bank_account, balance: 1)
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = -1

          expect do
            transfer_creator.make(value: transfer_value)
          end.to raise_error(::Bank::NegativeValueError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when account balance has sufficienty funds' do
        it 'expect change balance in credit and in debit account' do
          debit_account  = create(:bank_account, balance: 1)
          credit_account = create(:bank_account, balance: 0)

          transfer_creator = described_class.new(from_id: debit_account.id, to_id: credit_account.id)
          transfer_value   = 1

          expect { transfer_creator.make(value: transfer_value) }.to change(::Bank::Transaction, :count).by(2)
          expect(debit_account.reload.balance).to eq(0)
          expect(credit_account.reload.balance).to eq(1)
        end
      end
    end
  end
end
