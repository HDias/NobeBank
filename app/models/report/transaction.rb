module Report
  class Transaction
    include ActiveModel::API

    attr_accessor :account_id, :start_date, :end_date
    attr_reader :final_balance, :transactions

    validates :account_id, presence: true
    validates :start_date, presence: true, unless: -> { end_date.blank? }
    validates :end_date, presence: true, unless: -> { start_date.blank? }
    validates :end_date, comparison: { greater_than_or_equal_to: :start_date }, allow_blank: true
    validates :end_date, comparison: { less_than_or_equal_to: Date.current }, allow_blank: true

    def generate(transaction_model = ::Bank::Transaction)
      @transaction_model ||= transaction_model
      @transactions = []

      return if start_date.blank? || end_date.blank?

      @transactions = @transaction_model.by_range(account_id, date_range)

      final_balance_sum
    end

    def final_balance_sum
      last_balance = @transaction_model.less_than_date(account_id, start_date.to_date.beginning_of_day)

      range_balance = @transactions.sum(:value)

      @final_balance = last_balance + range_balance
    end

    def date_range
      start_date.to_date.beginning_of_day..end_date.to_date.end_of_day
    end
  end
end
