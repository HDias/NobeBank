require 'rails_helper'

RSpec.describe ::Bank::CreateCreditTransaction do
  context 'when initialize with wrong argument' do
    specify { expect { described_class.new(account_id: User.first) }.to raise_error(ArgumentError) }
    specify { expect { described_class.new(account_id: ::Bank::Account) }.to raise_error(ArgumentError) }
  end

  describe '.make' do
    context 'failure' do
      context 'when nickname is withdrawal' do
        xit 'expect raise expection'
      end

      context 'when account has been destroyed' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)
          account.destroy!

          credit_creator = described_class.new(account_id: account.id, user:)
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

          credit_creator = described_class.new(account_id: account.id, user:)
          credit_value   = -1

          expect do
            credit_creator.make(value: credit_value, nickname: 'deposit')
          end.to raise_error(::Bank::NegativeValueError).and change(::Bank::Transaction, :count).by(0)
        end
      end
    end

    context 'success' do
      context 'when account balance has sufficienty funds' do
        specify do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          credit_creator = described_class.new(account_id: account.id, user:)
          credit_value   = 1

          expect { credit_creator.make(value: credit_value, nickname: 'withdrawal') }.to change(::Bank::Transaction, :count).by(1)
        end

        it 'expect create bank_transaction with status sucess' do
          account = create(:bank_account, balance: 1)
          user    = create(:user)

          credit_value   = 1
          credit_creator = described_class.new(account_id: account.id, user:)
          credit_creator.make(value: credit_value, nickname: 'withdrawal')

          expect(credit_creator.transaction_model.success_status?).to be_truthy
        end
      end
    end
  end
end
