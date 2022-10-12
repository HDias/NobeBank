require 'rails_helper'

RSpec.describe ::Bank::Account, type: :model do
  describe 'soft_delete' do
    specify { is_expected.to act_as_paranoid }
  end

  describe 'validations' do
    specify { is_expected.to validate_presence_of(:agency) }
    specify { is_expected.to validate_presence_of(:account_number) }

    specify { should validate_uniqueness_of(:account_number).scoped_to(:agency) }
  end

  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
  end
end
