module Report
  class Transaction
    include ActiveModel::API

    attr_accessor :account_id, :start_date, :end_date
    attr_reader :final_balance, :transactions

    validates :account_id, presence: true
    validates :start_date, presence: true
    validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
    validates :end_date, comparison: { less_than_or_equal_to: Date.current }

    def generate(transaction_model = ::Bank::Transaction)
      @transaction_model ||= transaction_model

      transacations

      final_balance_sum
    end

    def final_balance_sum
      last_balance = @transaction_model.where(bank_account_id: account_id)
                                       .where('created_at < ?', start_date.to_date.beginning_of_day)
                                       .sum(:value)

      range_balance = @transactions.sum(:value)

      @final_balance = last_balance + range_balance
    end

    def time_range
      start_date.to_date.beginning_of_day..end_date.to_date.end_of_day
    end

    def transacations
      @transactions = @transaction_model.where(bank_account_id: account_id)
                                        .where(created_at: time_range)
    end
  end
end
