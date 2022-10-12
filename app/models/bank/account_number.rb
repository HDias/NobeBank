module Bank
  class AccountNumber
    def self.generate
      Random.new.bytes(5).bytes.join[0, 6]
    end
  end
end
