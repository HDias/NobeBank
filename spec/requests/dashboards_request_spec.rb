require 'rails_helper'

RSpec.describe ::Bank::DashboardsController, type: :request do
  describe 'GET .index' do
    context 'not loged' do
      it 'redirect do login path' do
        create(:bank_account)

        get bank_dashboards_url

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'loged' do
      it 'renders a successful response' do
        create(:bank_account)

        custom_sign_in create(:user)
        get bank_dashboards_url

        expect(response).to be_successful
      end
    end
  end
end
