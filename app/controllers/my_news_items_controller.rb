# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative, only: %i[new edit create_from_selected]
  before_action :set_representatives_list
  before_action :set_issues_list
  before_action :set_news_item, only: %i[edit update destroy]

  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
    redirect_to_news_item_or_render('News item was successfully created.',
                                    'An error occurred when creating the news item.')
  end

  def update
    redirect_to_news_item_or_render('News item was successfully updated.',
                                    'An error occurred when updating the news item.')
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative), notice: 'News was successfully destroyed.'
  end

  def select_representatives_issue
    render :select_representatives_issue
  end

  def create_from_selected
    selected_article = params[:articles][params[:selected_article_index]]

    @news_item = NewsItem.new(title:             selected_article['title'],
                              description:       selected_article['description'],
                              link:              selected_article['link'],
                              representative_id: params[:representative_id],
                              issue:             params[:issue])

    redirect_to_news_item_or_render('News Item was successfully created.', 'ERROR on Creating News Item.')
  end

  def search_articles
    if params[:news_item].present?
      set_selected_representative_issue
      @articles = fetch_articles
      mock_articles if Rails.env.test?

      if @articles.present?
        Rails.logger.debug 'zzzzzzz'
        Rails.logger.debug @articles
        render :display_articles
      else
        flash.now[:alert] = 'No articles found.'
        Rails.logger.debug 'bcd'
        redirect_to select_representative_issue_my_news_item_path(@representative)
      end
    else
      flash.now[:alert] = 'You must select a representative and an issue.'
      Rails.logger.debug 'abc'
      redirect_to select_representative_issue_my_news_item_path(@representative)
    end
    nil
  end

  def set_representative
    @representative = Representative.find(params[:representative_id])
  end

  def set_representatives_list
    @representatives_list = Representative.pluck(:name, :id)
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  def set_issues_list
    @issues_list = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security and Medicare',
                    'Abortion', 'Student Loans', 'Gun Control', 'Unemployment', 'Climate Change', 'Homelessness',
                    'Racism', 'Tax Reform', 'Net Neutrality', 'Religious Freedom', 'Border Security', 'Minimum Wage',
                    'Equal Pay']
  end

  def set_selected_representative_issue
    @selected_issue = params[:news_item][:issue]
    @selected_representative = Representative.find(params[:news_item][:representative_id])
    @representative = @selected_representative
  end

  def fetch_articles
    api_key = Rails.application.credentials[:NEWS_API_KEY]
    query = CGI.escape("#{@selected_representative.name} #{@selected_issue}")
    uri = URI("https://newsapi.org/v2/everything?q=#{query}&pageSize=5&apiKey=#{api_key}")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 10,
                               open_timeout: 10) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end
    JSON.parse(response.body)['articles'].first(5)
  end

  def mock_articles
    @articles = [
      { 'title' => 'Test Title', 'description' => 'Test Description', 'url' => 'http://testurl.com' }
    ]
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue)
  end

  def redirect_to_news_item_or_render(success_message, error_message)
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item), notice: success_message
    else
      render :new, error: error_message
    end
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
