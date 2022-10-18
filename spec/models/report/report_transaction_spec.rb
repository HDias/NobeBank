require 'rails_helper'

RSpec.describe ::Report::Transaction, type: :model do
  describe 'validations' do
    specify { is_expected.to validate_presence_of(:account_id) }
    specify {
      subject.end_date = Date.yesterday.to_s
      is_expected.to validate_presence_of(:start_date)
    }

    context 'when end_date is greater than start_date' do
      it 'record is not valid and adds greater_than_or_equal_to error to end_date attribute' do
        account = create(:bank_account)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: Date.current.to_s,
          end_date: Date.yesterday.to_s
        )

        expect(report_transaction.valid?).to be_falsey
        expect(report_transaction.errors[:end_date]).not_to be_empty
      end
    end

    context 'when end_date is greater than current_day' do
      it 'record is not valid and adds greater_than_or_equal_to error to end_date attribute' do
        account = create(:bank_account)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: Date.today.to_s,
          end_date: Date.yesterday.to_s
        )

        expect(report_transaction.valid?).to be_falsey
        expect(report_transaction.errors[:end_date]).not_to be_empty
      end
    end

    context 'when end_date nil or blank' do
      it 'record is not valid and adds greater_than_or_equal_to error to end_date attribute' do
        account = create(:bank_account)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: Date.today.to_s,
          end_date: nil
        )

        expect(report_transaction.valid?).to be_falsey
        expect(report_transaction.errors[:end_date]).not_to be_empty
      end
    end

    context 'when end_date and start_date be nil or blank' do
      it 'expect final_balance and transactions be nil' do
        account = create(:bank_account)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: '',
          end_date: nil
        )

        report_transaction.generate

        expect(report_transaction.valid?).to be_truthy
        expect(report_transaction.final_balance).to eq(nil)
        expect(report_transaction.transactions.length).to eq(0)
      end
    end

    context 'when end_date is less than start_date' do
      it "record is valid and doesn't add greater_than_or_equal_to error to end_date attribute" do
        account = create(:bank_account)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: Date.yesterday,
          end_date: Date.today
        )

        expect(report_transaction.valid?).to be_truthy
        expect(report_transaction.errors[:end_date]).to be_empty
      end
    end
  end

  describe '.generate' do
    context 'when has balance before start_date' do
      it 'expect #final_balance be value equal 10 and #transactions be empty' do
        account = create(:bank_account)
        create(:bank_credit_transaction, bank_account: account, value: 15, created_at: DateTime.current - 3.days)
        create(:bank_debit_transaction, bank_account: account, value: -5, created_at: DateTime.current - 2.days)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: Date.today.to_s,
          end_date: Date.today.to_s
        )

        report_transaction.generate

        expect(report_transaction.final_balance).to eq(10)
        expect(report_transaction.transactions).to be_empty
      end

      it 'expect #final_balance be value equal 10 and #transactions lenght be 1' do
        account = create(:bank_account)
        create(:bank_credit_transaction, bank_account: account, value: 15, created_at: DateTime.current - 3.days)
        create(:bank_debit_transaction, bank_account: account, value: -5, created_at: DateTime.current - 2.days)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: (Date.current - 2.days).to_s,
          end_date: (Date.current - 2.days).to_s
        )

        report_transaction.generate

        expect(report_transaction.final_balance).to eq(10)
        expect(report_transaction.transactions.length).to eq(1)
      end

      it 'expect #final_balance be value equal 15 and #transactions lenght be 1' do
        account = create(:bank_account)
        create(:bank_credit_transaction, bank_account: account, value: 15, created_at: DateTime.current - 3.days)
        create(:bank_debit_transaction, bank_account: account, value: -5, created_at: DateTime.current - 2.days)

        report_transaction = described_class.new(
          account_id: account.id,
          start_date: (Date.current - 3.days).to_s,
          end_date: (Date.current - 3.days).to_s
        )

        report_transaction.generate

        expect(report_transaction.final_balance).to eq(15)
        expect(report_transaction.transactions.length).to eq(1)
      end
    end
  end
end
