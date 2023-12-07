# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative, only: %i[create update new edit create_from_selected]
  before_action :set_representatives_list
  before_action :set_issues_list
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

  def select_representatives_issue
    render :select_representatives_issue
  end

  def create_from_selected
    # Create a news item from the selected article
    selected_article = params[:articles][params[:selected_article_index]]

    @news_item = NewsItem.new(
      title: selected_article['title'],
      description: selected_article['description'],
      link: selected_article['link'],
      representative_id: params[:representative_id],
      issue: params[:issue]
    )

    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News Item was successfully created.'
    else
      render :new, error: 'ERROR on Creating News Item.'
    end
  end

  def search_articles
    if params[:news_item].present?
      set_selected_representative_issue
      @articles = fetch_articles
      mock_articles if Rails.env.test?
  
      if @articles.present?
        p 'zzzzzzz'
        p @articles
        render :display_articles
        return
      else
        flash.now[:alert] = 'No articles found.'
        p 'bcd'
        redirect_to select_representative_issue_my_news_item_path(@representative)
        
        return
      end
    else
      flash.now[:alert] = 'You must select a representative and an issue.'
      p 'abc'
      redirect_to select_representative_issue_my_news_item_path(@representative)
      return
    end
    
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

  def set_issues_list
    @issues_list = ['Free Speech', 'Immigration', 'Terrorism', "Social Security and Medicare",
    'Abortion', 'Student Loans', 'Gun Control', 'Unemployment', 'Climate Change', 'Homelessness',
    'Racism', 'Tax Reform', "Net Neutrality", 'Religious Freedom', 'Border Security', 'Minimum Wage',
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
    
    # Set up HTTP request with timeout settings
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 10, open_timeout: 10) do |http|
      request = Net::HTTP::Get.new(uri)
      http.request(request)
    end
  
    JSON.parse(response.body)['articles'].first(5)
  end

  def mock_articles
    # mock articles for test
    @articles = [
      { 'title' => 'Test Title', 'description' => 'Test Description', 'url' => 'http://testurl.com' }
    ]
  end  
  
  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue)
  end
end
