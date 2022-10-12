class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bank_accounts, class_name: '::Bank::Account'

  acts_as_paranoid
end
