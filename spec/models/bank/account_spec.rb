require 'rails_helper'

RSpec.describe ::Bank::Account, type: :model do
  describe 'validations' do
    specify { is_expected.to validate_presence_of(:agency) }
    specify { is_expected.to validate_presence_of(:account_number) }

    specify { should validate_uniqueness_of(:account_number).scoped_to(:agency) }
  end
end
