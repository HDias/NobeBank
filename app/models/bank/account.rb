module Bank
  class Account < ApplicationRecord
    validates :agency, presence: true
    validates :account_number, presence: true

    validates :account_number, uniqueness: { scope: :agency }
  end
end
