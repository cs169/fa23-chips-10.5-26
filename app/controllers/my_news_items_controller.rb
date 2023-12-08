# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id)
  end

  def select_representative_and_issue
      # to show first page
  end

  def display_top_articles
    # show second page: top 5 articles from News API
    # use News API to get article data and give to views
    api = NewAPI.new("AIzaSyDIjv9r13ThBwuhQhsCfwdirCKdrWIQKec")
    
    # representative: representative, issue: issue, pageSize: 5 
    query_string = "#{params[:representative]} #{params[:issue]}"
    query_string += " pagesize:5"
    encoded_query = URI.encode(query_string)
    
    @top_articles = api.get_top_articles(query: { apiKey: @api_key, q: encoded_query })
  end
end
