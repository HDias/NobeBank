module Bank
  class AgencyNumber
    AGENCIES = %w[0001].freeze

    def self.get
      AGENCIES.first
    end
  end
end
