FactoryBot.define do
  factory :bank_account, class: 'Bank::Account' do
    account_number { Faker::Number.number(digits: 6) }
    agency { '0001' }

    user
  end
end
