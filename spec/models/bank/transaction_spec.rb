require 'rails_helper'

RSpec.describe ::Bank::Transaction, type: :model do
  describe 'validations' do

    specify { is_expected.to validate_presence_of(:kind) }
    specify do
      is_expected.to define_enum_for(:kind).with_values(
        credit: 'credit',
        debit: 'debit'
      ).backed_by_column_of_type(:string)
    end

    specify { is_expected.to  validate_numericality_of(:value).is_greater_than(0) }
    specify { is_expected.to validate_presence_of(:value) }

    specify { is_expected.to validate_length_of(:description).is_at_most(255) }

  end

  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
    specify { is_expected.to belong_to(:bank_account).class_name('::Bank::Account') }
  end
end
