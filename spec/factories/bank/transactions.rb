FactoryBot.define do
  statuses = Bank::Transaction.statuses.keys

  factory :bank_credit_transaction, class: 'Bank::Transaction' do
    kind { :credit }
    status { statuses.sample }
    nickname { %i[deposit transfer].sample }
    description { Faker::Lorem.paragraph }
    value { rand(1..100) }

    bank_account
    user
  end

  factory :bank_debit_transaction, class: 'Bank::Transaction' do
    kind { :debit }
    status { statuses.sample }
    nickname { %i[withdrawal transfer].sample }
    description { Faker::Lorem.paragraph }
    value { rand(1..100) }

    bank_account
    user
  end
end
