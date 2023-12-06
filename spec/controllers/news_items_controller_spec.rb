# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItemsController, type: :controller do
  let(:representative) { create(:representative) }
  let(:news_item) { create(:news_item, representative: representative, issue: 'Free Speech') }

  describe 'GET #index' do
    before { get :index, params: { representative_id: representative.id } }

    it 'assigns @news_items' do
      expect(assigns(:news_items)).to eq(representative.news_items)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { representative_id: representative.id, id: news_item.id } }

    it 'assigns @news_item' do
      expect(assigns(:news_item)).to eq(news_item)
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe '#set_representative' do
    before do
      controller.params[:representative_id] = representative.id
      controller.send(:set_representative)
    end

    it 'assigns @representative' do
      expect(assigns(:representative)).to eq(representative)
    end
  end
end
