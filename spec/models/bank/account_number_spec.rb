require 'rails_helper'

RSpec.describe ::Bank::AccountNumber do
  describe '.generate' do
    it 'expect return number with 6 caracteres' do
      account_number = described_class.generate

      expect(account_number.to_s.length).to eq(6)
    end
  end
end
