FactoryBot.define do
  factory :bank_credit_transaction, class: 'Bank::Transaction' do
    kind { :credit }
    status { :success }
    nickname { %i[deposit transfer].sample }
    description { Faker::Lorem.paragraph }
    value { rand(1..100) }
    created_at { DateTime.current }

    bank_account
    user
  end

  factory :bank_debit_transaction, class: 'Bank::Transaction' do
    kind { :debit }
    status { :success }
    nickname { %i[withdrawal transfer].sample }
    description { Faker::Lorem.paragraph }
    value { rand(1..100) }
    created_at { DateTime.current }

    bank_account
    user
  end
end
