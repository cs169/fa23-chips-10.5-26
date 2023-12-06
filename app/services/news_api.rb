# app/services/news_api.rb

require 'httparty'

class NewsAPI
  include HTTParty
  base_uri 'https://newsapi.org/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_top_articles(q)
    response = self.class.get('/everything', q)

    if response.success?
      return response.parsed_response['articles']
    else
      # failed
      return []
    end
  end
end
