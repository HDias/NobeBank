module Bank
  class Account < ApplicationRecord
    belongs_to :user

    validates :agency, presence: true
    validates :account_number, presence: true

    validates :account_number, uniqueness: { scope: :agency }

    validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    acts_as_paranoid

    scope :owner, ->(user_id) { where(user_id:) }

    def agency_account
      "Agência: #{agency}, Conta: #{account_number}"
    end
  end
end
