# frozen_string_literal: true

require 'rails_helper'

describe LoginController do
  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template('login')
    end
  end

  describe 'GET #google_oauth2' do
    it 'redirects to root_url after successful login' do
      allow(controller).to receive(:find_or_create_user).and_return(create(:user))
      get :google_oauth2
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET #github' do
    it 'redirects to root_url after successful login' do
      allow(controller).to receive(:find_or_create_user).and_return(create(:user))
      get :github
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'GET #already_logged_in' do
    it 'tells user is already logged in' do
      

  describe 'GET #logout' do
    it 'clears the current_user_id from session' do
      user = create(:user)
      session[:current_user_id] = user.id
      get :logout

      expect(session[:current_user_id]).to be_nil
    end

    it 'redirects to root_url with a logout notice' do
      get :logout
      expect(response).to redirect_to(root_url)
      expect(flash[:notice]).to eq('You have successfully logged out.')
    end
  end
end
