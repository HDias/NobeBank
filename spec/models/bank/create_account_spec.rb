require 'rails_helper'

RSpec.describe ::Bank::CreateAccount do
  describe '.valid?' do
    specify do
      user = create(:user)

      creator = described_class.new(user_id: user)

      expect(creator.valid?).to be_truthy
    end
  end

  describe '.save' do
    specify do
      user = create(:user)

      creator = described_class.new(user_id: user)

      expect{ creator.save }.to change(::Bank::Account, :count).by(1)
    end
  end
end
