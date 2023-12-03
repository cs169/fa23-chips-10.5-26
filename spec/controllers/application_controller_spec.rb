require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'OK'
    end
  end

  describe 'before_action :authenticated' do
    context 'when user is authenticated' do
      let(:user) { create(:user) } # Assuming you have a factory for user creation

      before do
        session[:current_user_id] = user.id
        get :index
      end

      it 'sets @authenticated to true' do
        expect(assigns(:authenticated)).to be true
      end

      it 'does not redirect' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not authenticated' do
      before do
        session[:current_user_id] = nil
        get :index
      end

      it 'sets @authenticated to false' do
        expect(assigns(:authenticated)).to be false
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
