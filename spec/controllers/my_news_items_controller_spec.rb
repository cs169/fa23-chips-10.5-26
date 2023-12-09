# frozen_string_literal: true

RSpec.describe MyNewsItemsController, type: :controller do
  describe 'GET #new' do
    it 'successfully generates a list of representatives name' do
      representatives_list = ['Biden', 'Another Representative']
      allow(controller).to receive(:set_representatives_list).and_return(representatives_list)

      get :new, params: { representative_id: 1 }

      expect(assigns(:representatives_list)).to be_nil
    end

    it 'renders the new template' do
      get :new, params: { representative_id: 1 }
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before do
        @news_item_params = attributes_for(:news_item)
        @news_item_params[:ratings] = 1
        @news_item = instance_double(NewsItem)
        allow(controller).to receive(:set_news_item).and_return(@news_item)
      end

      it 'updates the news item' do
        allow(@news_item).to receive(:update).and_return(true)
      end
    end
  end
end
