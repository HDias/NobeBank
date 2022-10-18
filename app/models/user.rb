class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bank_accounts, class_name: '::Bank::Account'

  validates :name, presence: true

  acts_as_paranoid

  def first_name
    name.split.first
  end
end
