module Bank
  class AccountNumber
    def self.generate(account_id)
      uniq_number = Random.new.bytes(5).bytes.join[0,5]

      "#{uniq_number}#{account_id}".to_i
    end
  end
end
