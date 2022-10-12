FactoryBot.define do
  kinds = Bank::Transaction.kinds.keys
  statuses = Bank::Transaction.statuses.keys

  factory :bank_transaction, class: 'Bank::Transaction' do
    kind { kinds.sample }
    status { statuses.sample }
    description { Faker::Lorem.paragraph }
    value { rand(1..100) }

    bank_account
    user

    trait :kind_credit do
      kind { :credit }
    end
    trait :kind_debit do
      kind { :debit }
    end

    factory :bank_transaction_credit, traits: [:kind_credit]
    factory :bank_transaction_debit, traits: [:kind_debit]
  end
end
