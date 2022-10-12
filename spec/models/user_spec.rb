require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'soft_delete' do
    specify { is_expected.to act_as_paranoid }
  end
end
