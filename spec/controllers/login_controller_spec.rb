# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let(:user) { create(:user, provider: 'google_oauth2', uid: '123') }

  describe 'GET #login' do
    it 'renders the login template' do
      get :login
      expect(response).to render_template(:login)
    end

    it 'redirects to user profile if already logged in' do
      log_in_user(user)
      get :login
      expect(response).to redirect_to(user_profile_path)
    end
  end

  describe 'GET #logout' do
    it 'clears current_user_id from session and redirects to root_path' do
      log_in_user(user)
      get :logout
      expect(session[:current_user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'private methods' do
    let(:user_info) { OmniAuth.config.mock_auth[:google_oauth2] }

    describe 'test find_or_create_user' do
      it 'finds an existing user' do
        user = create(:user, provider: 'google_oauth2', uid: user_info['uid'])
        found_user = controller.send(:find_or_create_user, user_info, :create_google_user)
        expect(found_user).to eq(user)
      end
    end

    describe 'test create_google_user' do
      it 'creates a new Google user' do
        allow(User).to receive(:create)
        controller.send(:create_google_user, user_info)
        expect(User).to have_received(:create).with(google_user_attributes(user_info))
      end
    end

    describe 'test create_github_user' do
      it 'creates a GitHub user' do
        user_info['info']['name'] = 'Jane Smith'
        user_info_form = create_user_form(user_info)
        allow(User).to receive(:create).with(user_info_form)
        controller.send(:create_github_user, user_info)
        expect(User).to have_received(:create)
      end
    end

    describe 'test already_logged_in' do
      it 'redirects to user they are if already logged in' do
        log_in_user(user)
        allow(controller).to receive(:redirect_to)
        controller.send(:already_logged_in)
        expect(controller).to have_received(:redirect_to).with(user_profile_path, notice: anything)
      end

      it 'does not redirect if not logged in' do
        allow(controller).to receive(:redirect_to)
        controller.send(:already_logged_in)
        expect(controller).not_to have_received(:redirect_to)
      end
    end
  end

  private

  def create_user_form(user_info)
    { uid: user_info['uid'], provider: User.providers[:github],
    first_name: 'Jane', last_name: 'Smith', email: user_info['info']['email'] }
  end

  def log_in_user(user)
    session[:current_user_id] = user.id
  end

  def create_and_find_user(user_info)
    create(:user, provider: 'google_oauth2', uid: user_info['uid'])
  end

  def google_user_attributes(user_info)
    {
      uid:        user_info['uid'],
      provider:   User.providers[:google_oauth2],
      first_name: user_info['info']['first_name'],
      last_name:  user_info['info']['last_name'],
      email:      user_info['info']['email']
    }
  end
end
