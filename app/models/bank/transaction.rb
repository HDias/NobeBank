module Bank
  class Transaction < ApplicationRecord
    enum kind: { credit: 'credit', debit: 'debit' }

    belongs_to :user
    belongs_to :bank_account, class_name: '::Bank::Account'

    validates :kind, presence: true
    validates :value, presence: true
    validates :value, numericality: { only_integer: true, greater_than: 0 }
    validates :description, length: { maximum: 255 }
  end
end
