require 'rails_helper'

RSpec.describe ::Bank::Account, type: :model do
  describe 'soft_delete' do
    specify { is_expected.to act_as_paranoid }
  end

  describe 'validations' do
    specify { is_expected.to validate_presence_of(:agency) }
    specify { is_expected.to validate_presence_of(:account_number) }

    specify { is_expected.to validate_uniqueness_of(:account_number).scoped_to(:agency) }

    specify { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
  end
end
