require 'rails_helper'

RSpec.describe ::Bank::AgencyNumber do
  describe '.generate' do
    it 'expect return number with 0001' do
      agency_number = described_class.get

      expect(agency_number).to eq('0001')
    end
  end
end
