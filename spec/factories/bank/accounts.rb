FactoryBot.define do
  factory :bank_account, class: 'Bank::Account' do
    account_number { Faker::Number.number(digits: 6) }
    agency { '0001' }
    balance { 0 }

    user
  end
end
