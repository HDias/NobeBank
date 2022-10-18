module Bank
  class Transaction < ApplicationRecord
    enum kind: { credit: 'credit', debit: 'debit' }, _suffix: true
    enum nickname: { deposit: 'deposit', withdrawal: 'withdrawal', transfer: 'transfer' }
    enum status: { success: 'success', error: 'error' }, _suffix: true

    belongs_to :bank_account, class_name: '::Bank::Account'
    belongs_to :user

    validates :kind,    presence: true
    validates :status,  presence: true
    validates :value,   presence: true

    validates :value, numericality: { only_integer: true }

    validates :description, length: { maximum: 255 }

    validates :nickname, exclusion: {
      in: ['withdrawal'],
      message: 'withdrawal is not valid to credit transaction'
    }, if: -> { credit_kind? }

    validates :nickname, exclusion: {
      in: ['deposit'],
      message: 'deposit is not valid to debit transaction'
    }, if: -> { debit_kind? }
  end
end
