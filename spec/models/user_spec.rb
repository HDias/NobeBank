require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'soft_delete' do
    specify { is_expected.to act_as_paranoid }
  end

  describe 'associations' do
    specify { is_expected.to have_many(:bank_accounts) }
  end
end
