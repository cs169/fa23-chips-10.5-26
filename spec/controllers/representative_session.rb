require 'rails_helper'

RSpec.describe SessionController, type: :controller do
  describe 'GET #require_login!' do
    context 'when user is logged in' do
      let(:user) { create(:user) }
      before do
        session[:current_user_id] = user.id
      end

      it 'assigns @current_user' do
        get :require_login!
        expect(assigns(:current_user)).to eq(user)
      end

      it 'does not redirect' do
        get :require_login!
        expect(response).not_to have_http_status(:redirect)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login_url' do
        get :require_login!
        expect(response).to redirect_to(login_url)
      end

      it 'sets session[:destination_after_login]' do
        get :require_login!
        expect(session[:destination_after_login]).to eq(request.env['REQUEST_URI'])
      end
    end
  end
end
