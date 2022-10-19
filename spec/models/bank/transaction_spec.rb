require 'rails_helper'

RSpec.describe ::Bank::Transaction, type: :model do
  describe 'validations' do
    # nickname
    specify { is_expected.to validate_presence_of(:kind) }
    specify do
      is_expected.to define_enum_for(:nickname).with_values(
        deposit: 'deposit',
        withdrawal: 'withdrawal',
        transfer: 'transfer',
        tax: 'tax'
      ).backed_by_column_of_type(:string)
    end

    # kind
    specify { is_expected.to validate_presence_of(:kind) }
    specify do
      is_expected.to define_enum_for(:kind).with_values(
        credit: 'credit',
        debit: 'debit'
      ).backed_by_column_of_type(:string).with_suffix
    end

    # status
    specify { is_expected.to validate_presence_of(:status) }
    specify do
      is_expected.to define_enum_for(:status).with_values(
        success: 'success',
        error: 'error'
      ).backed_by_column_of_type(:string).with_suffix
    end

    # value
    specify { is_expected.to validate_numericality_of(:value) }
    specify { is_expected.to validate_presence_of(:value) }

    specify { is_expected.to validate_length_of(:description).is_at_most(255) }
  end

  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
    specify { is_expected.to belong_to(:bank_account).class_name('::Bank::Account') }
  end
end
