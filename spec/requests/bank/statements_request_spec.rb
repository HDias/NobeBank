require 'rails_helper'

RSpec.describe ::Bank::StatementsController, type: :request do
  describe 'GET .index' do
    context 'not loged' do
      it 'redirect do login path' do
        get bank_statements_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      it 'renders a successful response' do
        user    = create(:user)
        account = create(:bank_account, user:)

        custom_sign_in user
        get bank_statements_path(current_account_id: account.id)

        expect(response).to be_successful
      end
    end
  end
end
